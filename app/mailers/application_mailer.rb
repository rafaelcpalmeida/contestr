class ApplicationMailer < ActionMailer::Base
  default from: "Contestr <#{ENV['STMP_USERNAME']}>"

  def register_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome')
  end

  def new_project(project)
    @project = project
    @doc = Document.find_by(project_id: @project.id)
    users = User.where(userType: 2)
    unless @doc.nil?
      attachments[@doc.filename] = { mime_type: @doc.content_type, content: @doc.file_contents }
    end

    users.each do |user|
      @username = user.name
      mail(to: user.email,
           subject: 'New project'
      )
    end
  end
end
