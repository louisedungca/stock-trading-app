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
    shares_to_buy = params[:shares].to_f

    if shares_to_buy <= 0
      flash[:alert] = 'Number of shares must be greater than 0'
    else
      @data = IEX::Api::Client.new.quote(@stock_symbol)
      price_per_share = @data.latest_price
      total_cost = price_per_share * shares_to_buy

      if current_user.balance >= total_cost
        # Update user's balance
        current_user.update(balance: current_user.balance - total_cost)

        # Update stock inventory
        update_stock_inventory(@data, shares_to_buy)

        # Record the transaction
        Transaction.create!(
          user: current_user,
          transaction_type: 'buy',
          stock_symbol: @data.symbol,
          company_name: @data.company_name,
          shares: shares_to_buy,
          price_per_share:
        )

        flash[:notice] = "#{@data.symbol} stock purchased successfully"
      else
        flash[:alert] = 'Insufficient balance'
      end
    end

    redirect_back(fallback_location: trader_trade_path)
  end

  def sell
    @stock_symbol = params[:symbol].to_s.upcase
    stock = current_user.stocks.find_by(stock_symbol: @stock_symbol)
    shares_to_sell = params[:shares].to_f

    if shares_to_sell <= 0
      flash[:alert] = 'Number of shares must be greater than 0'
    elsif stock.present? && stock.shares >= shares_to_sell
      @data = IEX::Api::Client.new.quote(@stock_symbol)
      price_per_share = @data.latest_price
      total_sale = price_per_share * shares_to_sell

      # Update user's balance
      current_user.update(balance: current_user.balance + total_sale)

      # Update stock inventory
      stock.update(shares: stock.shares - shares_to_sell)

      # Record the transaction
      Transaction.create!(
        user: current_user,
        transaction_type: 'sell',
        stock_symbol: @data.symbol,
        company_name: @data.company_name,
        shares: shares_to_sell,
        price_per_share:
      )
      flash[:notice] = "#{@data.symbol} stock sold successfully"
    else
      flash[:alert] = 'Insufficient shares'
    end
    redirect_back(fallback_location: trader_trade_path)
  end

  private

  def update_stock_inventory(data, shares)
    stock = current_user.stocks.find_by(stock_symbol: data.symbol)
    if stock.present?
      stock.update(shares: stock.shares + shares)
    else
      logo = IEX::Api::Client.new.logo(data.symbol)
      Stock.create!(
        user: current_user,
        shares:,
        stock_symbol: data.symbol,
        company_name: data.company_name,
        logo_url: logo.url
      )
    end
  end
end
