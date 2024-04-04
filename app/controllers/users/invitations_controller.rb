# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  before_action :authenticate_admin!

  def after_invite_path_for(inviter, invitee)
    admin_dashboard_path
    #insert alert notice here
  end

  private

  def authenticate_admin!
    redirect_to trader_dashboard_path, alert: "You are not authorized to perform this action." unless current_user.admin?
  end

  def invite_params # GPT
    params.require(:user).permit(:email, :role).tap do |whitelisted|
      whitelisted[:username] = params[:user][:email].split('@').first if params[:user][:email].present?
    end
  end
end
