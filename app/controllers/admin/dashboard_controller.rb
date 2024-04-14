class Admin::DashboardController < ApplicationController
  layout 'admin_layout'

  def index
    @pending_traders = User.pending_traders
    @confirmed_email_traders = User.confirmed_email_traders
    @approved_traders = User.approved_traders

    @traders = User.sorted_traders
    @pagy, @confirmed_email_traders = pagy(@confirmed_email_traders, items: 8)
  end
end
