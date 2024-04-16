class Trader::TradesController < TradersController
  layout 'dashboard_layout'

  def index
    return unless params[:symbol].present?

    begin
      @data = IEX::Api::Client.new.quote(@stock_symbol)
    rescue IEX::Errors::SymbolNotFoundError => e
      flash[:alert] = "Stock symbol not found: #{@stock_symbol}"
      redirect_to trader_trade_path
    end
  end

  def buy
    stock_symbol = params[:symbol]

    if Transaction.buy_shares(current_user, stock_symbol, transaction_params[:shares].to_f)
      flash[:notice] = "#{stock_symbol} stock purchased successfully"
    else
      flash[:alert] = 'Error'
    end
    redirect_back(fallback_location: trader_trade_path)
  end

  private

  def transaction_params
    params.require(:transaction).permit(:shares, :amount)
  end
end
