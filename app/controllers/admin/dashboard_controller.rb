class Admin::DashboardController < ApplicationController
  before_action :set_pending_approvals, only: [:index, :pending_approvals]
  layout "dashboard_layout"

  def index
    @traders = User.approved_traders
  end

  def pending_approvals
  end

  private

  def set_pending_approvals
    @pending_approvals = Status.where(status_type: "pending")
  end
end
