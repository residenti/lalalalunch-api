# Preview all emails at http://localhost:3000/rails/mailers/confirmation_mailer
class ConfirmationMailerPreview < ActionMailer::Preview
  def registration_completed
    ConfirmationMailer.with(user: User.first).registration_completed
  end
end
