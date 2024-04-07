class UserMailer < ApplicationMailer
  before_action :set_user
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.user_approved.subject
  #
  def user_approved
    mail(
      to: @user.email,
      subject: "You're Approved! Let's Start Trading with Stocker!"
    )
  end

  def user_revoked
    mail(
      to: @user.email,
      subject: "Access Revocation: Trading Features on Stocker"
    )
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
