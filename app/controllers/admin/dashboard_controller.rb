class Admin::DashboardController < ApplicationController
  before_action :set_traders
  layout 'admin_layout'

  def index
    @traders = User.sorted_traders
    @pagy, @confirmed_email_traders = pagy(@confirmed_email_traders, items: 8)
  end

  private

  def set_traders
    @pending_traders = User.pending_traders
    @confirmed_email_traders = User.confirmed_email_traders
    @approved_traders = User.approved_traders
  end
end
