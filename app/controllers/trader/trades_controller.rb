class Trader::TradesController < ApplicationController
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
    shares_to_buy = params[:shares].to_i
    @data = IEX::Api::Client.new.quote(@stock_symbol)
    price_per_share = @data.latest_price
    total_cost = price_per_share * shares_to_buy

    if current_user.balance >= total_cost
      # Update user's balance
      current_user.update(balance: current_user.balance - total_cost)

      # Record the transaction
      Transaction.create!(
        user: current_user,
        transaction_type: 'buy',
        stock_symbol: @data.symbol,
        shares: shares_to_buy,
        price_per_share:
      )

      # Update stock inventory
      update_stock_inventory(@data.symbol, shares_to_buy)

      flash[:notice] = 'Stock purchased successfully'
    else
      flash[:alert] = 'Insufficient balance'
    end
    redirect_back(fallback_location: trader_trade_path)
  end

  def sell
    @stock_symbol = params[:symbol].to_s.upcase
    shares_to_sell = params[:shares].to_i
    stock = current_user.stocks.find_by(stock_symbol: @stock_symbol)

    if stock.present? && stock.shares >= shares_to_sell
      @data = IEX::Api::Client.new.quote(@stock_symbol)
      price_per_share = @data.latest_price
      total_sale = price_per_share * shares_to_sell

      # Update user's balance
      current_user.update(balance: current_user.balance + total_sale)

      # Update user's stock inventory
      stock.update(shares: stock.shares - shares_to_sell)

      # Record the transaction
      Transaction.create!(
        user: current_user,
        transaction_type: 'sell',
        stock_symbol: @data.symbol,
        shares: shares_to_sell,
        price_per_share:
      )
      flash[:notice] = 'Stock sold successfully'
    else
      flash[:alert] = 'Insufficient shares'
    end
    redirect_back(fallback_location: trader_trade_path)
  end

  private

  def update_stock_inventory(symbol, shares)
    stock = current_user.stocks.find_by(stock_symbol: symbol)
    if stock.present?
      stock.update(shares: stock.shares + shares)
    else
      Stock.create!(
        user: current_user,
        shares:,
        stock_symbol: symbol
      )
    end
  end
end
