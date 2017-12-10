class SubmissionsController < ApplicationController
  before_action :authorize
  require 'FileUtils'
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
    file_path = "public/uploads/#{project_id}/#{current_user.id}/#{filename}"

    partial_path = File.dirname(file_path)

    if Submission.exists?(:user_id => current_user.id, :project_id => project_id)
      FileUtils.rm_rf(partial_path)
      Submission.destroy(Submission.find_by(:user_id => current_user.id, :project_id => project_id).id)
    end



    @submissions = Submission.new({:user_id => current_user.id, :project_id => project_id, :projectKey => key, :title => title, :attachment => file_path})

    if @submissions.save
      FileUtils.mkpath partial_path unless File.exist?(partial_path)

      File.open(File.path(file_path), 'w') { |file| file.write(code) }
      redirect_to '/dashboard'
    else
      redirect_to "/submissions/new?project_id=#{project_id}"
    end
  end
end
