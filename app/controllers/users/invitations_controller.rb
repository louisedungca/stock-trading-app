# frozen_string_literal: true

class Users::InvitationsController < Devise::InvitationsController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    redirect_to trader_dashboard_path, alert: "You are not authorized to perform this action." unless current_user.admin?
  end
end
