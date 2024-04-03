class Admin::DashboardController < ApplicationController

  def index
    @traders = User.approved_traders
    @pending_approvals = Status.where(status_type: "pending")
  end
end
