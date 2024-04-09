class Trader::TradeController < ApplicationController
  layout 'dashboard_layout'

  def index
    @trader_status = current_user.status&.status_type
    return unless params[:symbol].present?

    @stock_symbol = params[:symbol].to_s.upcase

    begin
      @data = IEX::Api::Client.new.quote(@stock_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      flash[:alert] = "Stock symbol not found: #{@stock_symbol}"
      redirect_to trader_trade_path
    end
  end

  def buy
    @stock_symbol = params[:symbol].to_s.upcase
    @data = IEX::Api::Client.new.quote(@stock_symbol)
    shares = params[:shares].to_i
    price_per_share = @data.latest_price
    total_cost = price_per_share * shares

    if current_user.balance >= total_cost
      # Update user's balance
      current_user.update(balance: current_user.balance - total_cost)

      # Record the transaction
      Transaction.create!(
        user: current_user,
        transaction_type: 'buy',
        stock_symbol: @data.symbol,
        shares:,
        price_per_share:
      )

      flash[:success] = 'Stock purchased successfully'
    else
      flash[:alert] = 'Insufficient balance'
    end
  end
end
