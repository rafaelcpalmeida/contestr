class ApplicationMailer < ActionMailer::Base
  default from: "Contestr <#{ENV['STMP_USERNAME']}>"

  def register_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome')
  end

  def new_project(project, email, username)
    @project = project
    @username = username
    mail(to: email,
         subject: 'New project'
    )
  end

  def new_project_with_pdf(project, email, username, doc)
    attachments[doc.filename] = { mime_type: doc.content_type, content: doc.file_contents }
    @project = project
    @username = username
    mail(to: email,
         subject: 'New project'
    )
  end
end
