class Trader::WithdrawController < TradersController
  include CurrencyHelper
  # before_action :ensure_frame_response
  layout 'dashboard_layout'

  def index
    @balance = current_user.balance
  end

  def update
    amount = params[:amount].to_f

    if Transaction.withdraw(current_user, amount)
      flash[:notice] = "Successfully cashed out #{format_currency(amount, unit: '$')}."
    else
      flash[:alert] = 'Failed to withdraw. Please try again.'
    end
    redirect_to trader_dashboard_path
  end

  private

  def ensure_frame_response
    return if Rails.env.test?
    redirect_to trader_dashboard_path unless turbo_frame_request?
  end
end
