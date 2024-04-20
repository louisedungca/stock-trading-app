class Trader::TransactionsController < TradersController
  layout 'dashboard_layout'

  def index
    @transactions = current_user.transactions.includes(:stock).filter_by_type(params[:filter]).order(updated_at: :desc)
    @transaction_types = Transaction::TRANSACTION_TYPES
    @pagy, @transactions = pagy(@transactions)
  end
end
