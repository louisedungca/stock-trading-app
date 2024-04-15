class Trader::PortfoliosController < TradersController
  layout 'dashboard_layout'

  def index
    @stocks = case params[:filter]
              when 'asc'
                current_user.stocks.order(:shares)
              else
                current_user.stocks.order(shares: :desc)
              end

    @pagy, @stocks = pagy_array(@stocks) || pagy(@stocks) ## pagy stuff
    @total_portfolio_value = 0.0

    # Fetch quote for each stock
    @stock_quotes = {}
    @stocks.each do |stock|
      @stock_quotes[stock.stock_symbol] = IEX::Api::Client.new.quote(stock.stock_symbol)
      total_price = @stock_quotes[stock.stock_symbol].latest_price * stock.shares
      @total_portfolio_value += total_price
    end
  end
end
