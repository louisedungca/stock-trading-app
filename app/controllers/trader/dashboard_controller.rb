class Trader::DashboardController < ApplicationController
  before_action :check_status
  layout "dashboard_layout"

  def index
  end

  private

  def check_status
    if current_user.trader? && current_user.status&.status_type == "pending" && !current_user.confirmed?
      sign_out(current_user)
      redirect_to pending_verification_page_path
    end
  end
end
