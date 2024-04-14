class Trader::CashInController < TradersController
  include CurrencyHelper
  layout 'dashboard_layout'

  def index
    @balance = current_user.balance
  end

  def update
    amount = params[:amount].to_f

    if amount <= 0
      flash[:alert] = 'Invalid amount. Please enter a value greater than 0.'
      redirect_to trader_cash_in_path
      return
    end

    current_user.balance += amount

    if current_user.save
      Transaction.create!(
        user: current_user,
        transaction_type: 'cash_in',
        amount:
      )
      flash[:notice] = "Successfully cashed in #{format_currency(amount, unit: "$")}."
      redirect_to trader_dashboard_path
    else
      flash[:alert] = 'Failed to cash in. Please try again.'
      redirect_to trader_cash_in_path
    end
  end

  private

  def cash_in_params
    params.require(:user).permit(:amount)
  end
end
