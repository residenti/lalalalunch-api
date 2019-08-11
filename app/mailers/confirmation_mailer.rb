class ConfirmationMailer < ApplicationMailer
  default from: 'lalalalunch.api@gmail.com'

  def registration_completed
    @user = params[:user]
    mail(to: @user.email, subject: '【らららランチAPI】ユーザー登録手続き完了')
  end
end
