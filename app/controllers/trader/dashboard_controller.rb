class Trader::DashboardController < TradersController
  layout 'dashboard_layout'

  def index
    @total_portfolio_value = 0.0

    # Fetch quote for each stock
    @stock_quotes = {}
    @stocks.each do |stock|
      stock_symbol = stock[:stock_symbol]
      @stock_quotes[stock_symbol] = IEX::Api::Client.new.quote(stock_symbol)

      total_price = @stock_quotes[stock_symbol].latest_price * stock[:total_shares]
      @total_portfolio_value += total_price
    end
  end

  def market
  end

end
