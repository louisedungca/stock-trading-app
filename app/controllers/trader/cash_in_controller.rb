class Trader::CashInController < TradersController
  include CurrencyHelper
  before_action :ensure_frame_response
  layout "dashboard_layout"

  def index
    @balance = current_user.balance
  end

  def update
    amount = params[:amount].to_f

    if Transaction.cash_in(current_user, amount)
      flash[:notice] = "Successfully cashed in #{format_currency(amount, unit: "$")}."
      redirect_to trader_dashboard_path
    else
      flash[:alert] = "Failed to cash in. Please try again."
      redirect_to trader_cash_in_path
    end
  end

  private

  def ensure_frame_response
    return unless Rails.env.development?
    redirect_to trader_dashboard_path unless turbo_frame_request?
  end
end
