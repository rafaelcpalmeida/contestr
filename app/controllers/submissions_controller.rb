class SubmissionsController < ApplicationController
  before_action :authorize

  layout 'dashboard'

  def new
    @project = Project.find(params[:project_id])
    @languages = ActiveSupport::JSON.decode(@project.languages)
  end

  def upload
    code = params[:submission][:code].gsub! '<br>', "\n"
    language = params[:submission][:language]
    project_id = params[:submission][:project_id]
    project = Project.find(project_id)
    title = "#{current_user.name} #{project.title}"
    key = "#{current_user.name}_#{project.title}"

    filename = "main.#{language}"

    if Submission.exists?(:user_id => current_user.id, :project_id => project_id)
      system("cd public/uploads/#{project_id}/ && rm -d -r *")
      Submission.destroy(Submission.find_by(:user_id => current_user.id, :project_id => project_id).id)
    end

    @submissions = Submission.new({:user_id => current_user.id, :project_id => project_id, :projectKey => key, :title => title, :attachment => filename})

    if @submissions.save
      path = "public/uploads/#{project_id}/#{current_user.id}"
      system("mkdir -p #{path}")
      File.open("#{path}/#{filename}", 'w') { |file| file.write(code)}
      redirect_to '/dashboard'
    else
      redirect_to "/submissions/new?project_id=#{project_id}"
    end
  end
end
