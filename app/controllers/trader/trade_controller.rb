class Trader::TradeController < ApplicationController
  layout 'dashboard_layout'

  def index
    @trader_status = current_user.status&.status_type
    return unless params[:symbol].present?

    begin
      @stock_symbol = params[:symbol].to_s.upcase
      @data = IEX::Api::Client.new.quote(@stock_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      flash[:alert] = "Stock symbol not found: #{params[:symbol]}"
    end
  end
end
