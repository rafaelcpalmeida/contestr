class SubmissionsController < ApplicationController
  before_action :authorize

  layout 'dashboard'

  def new
    @project = Project.find(params[:project_id])
  end

  def upload
    project_id = params[:submission][:project_id]
    project = Project.find(project_id)
    title = "#{current_user.name} #{project.title}"
    key = "#{current_user.name}_#{project.title}"

    @submissions = Submission.new({:user_id => current_user.id, :project_id => project_id, :projectKey => key, :title => title, :attachment => params[:submission][:attachment]})

    if @submissions.save
      system("echo $'sonar.projectKey=#{project_id}:#{current_user.id}\nsonar.projectName=#{current_user.name}_#{project.title}\nsonar.projectVersion=1.0\nsonar.sources=#{params[:submission][:attachment].original_filename}' > public/uploads/#{project_id}/#{current_user.id}/sonar-project.properties")
      system("cd public/uploads/#{project_id}/#{current_user.id}/ && sonar-scanner")
      redirect_to '/dashboard'
    else
      redirect_to "/submissions/new?project_id=#{project_id}"
    end
  end
end
