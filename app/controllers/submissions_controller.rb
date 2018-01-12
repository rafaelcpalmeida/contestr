class SubmissionsController < ApplicationController
  before_action :authorize
  require 'FileUtils'
  layout 'dashboard'
  include SubmissionsHelper

  def new
    @project = Project.find(params[:project_id])
    @languages = ActiveSupport::JSON.decode(@project.languages)
  end

  def upload
    project_id = params[:submission][:project_id]
    file_name = params[:submission][:attachment].original_filename
    base_path = `pwd`
    file_path = "#{base_path.strip}/public/uploads/#{project_id}/#{current_user.id}/#{file_name}"

    @submissions = Submission.new(user_id: current_user.id,
                                  project_id: project_id,
                                  attachment: params[:submission][:attachment])
    if @submissions.save
      Thread.new do
        analyze_process file_path, 8, 4, 4

        # TODO: store the return of the method above on the database
      end

      redirect_to '/dashboard'
    else
      redirect_to "/submissions/new?project_id=#{project_id}"
    end
  end
end