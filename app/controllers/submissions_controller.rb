class SubmissionsController < ApplicationController
  before_action :authorize
  require 'FileUtils'
  layout 'dashboard'
  include SubmissionsHelper

  def new
    @project = Project.find(params[:project_id])

    if Time.now.strftime("%d/%m/%Y %H:%M:%S") > @project.closeTime
      redirect_to '/dashboard'
    end

    @languages = ActiveSupport::JSON.decode(@project.languages)
  end

  def upload
    project_id = params[:submission][:project_id]

    project_close_time = Project.find(project_id).closeTime

    if Time.now.strftime("%d/%m/%Y %H:%M:%S") > project_close_time
      flash[:error] = 'Tempo expirado.'
      redirect_to "/projects/details?id=#{project_id}"
    else
      file_name = params[:submission][:attachment].original_filename
      base_path = `pwd`
      file_path = "#{base_path.strip}/public/uploads/#{project_id}/#{current_user.id}/"

      @submissions = Submission.new(user_id: current_user.id,
                                    project_id: project_id,
                                    attachment: params[:submission][:attachment])
      if @submissions.save
        Thread.new do
          analyze_process @submissions, file_path, file_name, 8, 4, 4
        end

        redirect_to '/dashboard'
      else
        redirect_to "/submissions/new?project_id=#{project_id}"
      end
    end
  end
end