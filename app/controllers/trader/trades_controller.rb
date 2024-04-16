class Trader::TradesController < TradersController
  layout 'dashboard_layout'

  def index
    return unless params[:stock_symbol].present?

    begin
      @data = IEX::Api::Client.new.quote(@stock_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      flash[:alert] = "Stock symbol not found: #{@stock_symbol}"
      redirect_to trader_trade_path
    end
  end

  def buy
    stock_symbol = params[:stock_symbol]
    shares = params[:shares].to_f

    if Transaction.buy_shares(current_user, stock_symbol, shares)
      flash[:notice] = "#{stock_symbol} stock purchased successfully"
    else
      flash[:alert] = 'Error'
    end
    redirect_back(fallback_location: trader_trade_path)
  end

end
