class Trader::TradesController < TradersController
  before_action :set_params, except: :index
  layout 'dashboard_layout'

  def index
    return unless params[:stock_symbol].present?

    @data = IEX::Api::Client.new.quote(@stock_symbol)
  rescue IEX::Errors::SymbolNotFoundError => e
    flash[:alert] = "Stock symbol not found: #{@stock_symbol}"
    redirect_to trader_trade_path
  end

  def buy
    if Transaction.buy_shares(current_user, @stock_symbol, @shares)
      flash[:notice] = "#{@stock_symbol} stock purchased successfully"
      redirect_to trader_portfolio_path
    else
      error_message = if current_user.errors.any?
                        current_user.errors.full_messages.join('. ')
                      else
                        'Oops. There was a problem in buying stock shares.'
                      end
      flash[:alert] = error_message
      redirect_back(fallback_location: trader_trade_path)
    end
  end

  def sell
    if Transaction.sell_shares(current_user, @stock_symbol, @shares)
      flash[:notice] = "#{@stock_symbol} stock sold successfully"
      redirect_to trader_portfolio_path
    else
      error_message = if current_user.errors.any?
                        current_user.errors.full_messages.join('. ')
                      else
                        'Oops. There was a problem in selling stock shares.'
                      end
      flash[:alert] = error_message
      redirect_back(fallback_location: trader_trade_path)
    end
  end

  private

  def set_params
    @stock_symbol = params[:stock_symbol].upcase
    if params[:buy_shares].present?
      @shares = params[:buy_shares].to_f
    elsif params[:sell_shares].present?
      @shares = params[:sell_shares].to_f
    end
  end
end
