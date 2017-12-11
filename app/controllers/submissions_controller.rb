class SubmissionsController < ApplicationController
  before_action :authorize
  require 'FileUtils'
  layout 'dashboard'

  def new
    @project = Project.find(params[:project_id])
    @languages = ActiveSupport::JSON.decode(@project.languages)
  end

  def upload
    project_id = params[:submission][:project_id]
    @submissions = Submission.new(user_id: current_user.id,
                                  project_id: project_id,
                                  attachment: params[:submission][:attachment])
    if @submissions.save
      redirect_to '/dashboard'
    else
      redirect_to "/submissions/new?project_id=#{project_id}"
    end
  end
end
