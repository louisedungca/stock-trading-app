class Trader::PortfoliosController < TradersController
  layout 'dashboard_layout'

  def index
    @stocks = Stock.group_similar_stocks(current_user)
    @pagy, @stocks = pagy_array(@stocks) || pagy(@stocks) # pagy stuff
    @total_portfolio_value = 0.0

    # to fetch quote for each stock
    @stock_quotes = {}
    @stocks.each do |stock|
      stock_symbol = stock[:stock_symbol]

      @stock_quotes[stock_symbol] = IEX::Api::Client.new.quote(stock_symbol)
      total_price = @stock_quotes[stock_symbol].latest_price * stock[:total_shares]
      @total_portfolio_value += total_price
    end
  end
end
