# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  before_action :validate_uniqueness, only: :create

  def create
    super
  end

  def after_invite_path_for(_inviter, _invitee)
    admin_dashboard_path
    # insert alert notice here
  end

  private

  def validate_uniqueness
    email = params[:user][:email]
    username = email.split('@').first.downcase # Assuming username is derived from the part before the @ symbol

    return unless User.exists?(email:) || User.exists?(username:)

    self.resource = resource_class.new(invite_params)
    resource.errors.add(:base, 'Email or username is already taken')
    render :new
  end

  def invite_params # GPT
    params.require(:user).permit(:email, :role).tap do |whitelisted|
      whitelisted[:username] = params[:user][:email].split('@').first if params[:user][:email].present?
    end
  end
end
