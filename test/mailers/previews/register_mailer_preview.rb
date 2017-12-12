# Preview all emails at http://localhost:3000/rails/mailers/register_mailer
class RegisterMailerPreview < ActionMailer::Preview
  def sample_mail_preview
    RegisterMailer.sample_email(User.first)
  end
end
