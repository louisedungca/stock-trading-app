class TradersController < ApplicationController
  before_action :check_status, :set_trader_status

  private

  def check_status
    return unless current_user.trader? && @trader_status == 'pending' && !current_user.confirmed?

    sign_out(current_user)
    redirect_to pending_verification_page_path
  end

  def set_trader_status
    @trader_status = current_user.status&.status_type
  end
end
