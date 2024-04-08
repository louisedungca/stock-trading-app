class Admin::DashboardController < ApplicationController
  layout "dashboard_layout"

  def index
    @pending_traders = User.pending_traders
    @confirmed_email_traders = User.confirmed_email_traders
    @approved_traders = User.approved_traders

    @traders = @pending_traders + @confirmed_email_traders + @approved_traders
  end

  def pending_approvals
  end

end
