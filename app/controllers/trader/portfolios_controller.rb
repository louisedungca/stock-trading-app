class Trader::PortfoliosController < ApplicationController
  layout 'dashboard_layout'

  def index
    @trader_status = current_user.status&.status_type
    @stocks = case params[:filter]
              when 'asc'
                current_user.stocks.order(:shares)
              else

                current_user.stocks.order(shares: :desc)
              end
    @pagy, @stocks = pagy_array(@stocks) || pagy(@stocks)
  end
end
