class Trader::PortfoliosController < TradersController
  layout 'dashboard_layout'

  def index
    @stocks = case params[:filter]
              when 'asc'
                current_user.stocks.order(:shares)
              else
                current_user.stocks.order(shares: :desc)
              end

    @pagy, @stocks = pagy_array(@stocks) || pagy(@stocks)
  end
end
