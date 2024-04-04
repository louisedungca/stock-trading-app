class Users::InvitationsController < Devise::InvitationsController
  before_action :check_admin

  private

  def check_admin
    unless current_user.role = "admin"
      flash[:alert] = "Only admins can send invitations."
      redirect_to trader_dashboard_path
    end
  end
end
