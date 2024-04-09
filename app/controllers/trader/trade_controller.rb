class Trader::TradeController < ApplicationController
  layout 'dashboard_layout'

  def index
    @trader_status = current_user.status&.status_type
    return unless params[:symbol].present?

    begin
      stock_symbol = params[:symbol]
      @data = IEX::Api::Client.new.quote(stock_symbol.to_s)
    rescue IEX::Errors::SymbolNotFoundError => e
      flash[:alert] = "Stock symbol not found: #{stock_symbol}"
    end
  end
end
