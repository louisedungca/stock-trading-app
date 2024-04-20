class TradersController < ApplicationController
  before_action :authorize_trader, :check_status, :set_trader_status, :set_stock_symbol, :set_stocks_per_trader

  private

  def authorize_trader
    redirect_to root_path, alert: "Access denied. You are not a trader." unless current_user.trader?
  end

  def check_status
    return unless current_user.trader? && @trader_status == 'pending' && !current_user.confirmed?

    sign_out(current_user)
    redirect_to pending_verification_page_path
  end

  def set_trader_status
    @trader_status = current_user.status&.status_type
  end

  def set_stock_symbol
    @stock_symbol = params[:stock_symbol].to_s.upcase
  end

  def set_stocks_per_trader
    @stocks = Stock.group_similar_stocks(current_user)
  end
end
