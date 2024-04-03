class Trader::DashboardController < ApplicationController
  before_action :check_status

  def index
  end

  private

  def check_status
    if current_user.trader? && current_user.status&.status_type == "pending"
      sign_out(current_user)
      redirect_to pending_approval_page_path
    else
      redirect_to trader_dashboard_path
    end
  end

end
