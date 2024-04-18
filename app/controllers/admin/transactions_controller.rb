class Admin::TransactionsController < AdminsController
  before_action :transaction_params
  layout 'dashboard_layout'

  def index
    @q = Transaction.ransack(params[:q])
    @transactions = @q.result.includes(:user, :stock)
    # @transactions = @transactions.filter_by_type(params[:filter])
    @transaction_types = Transaction::TRANSACTION_TYPES
    @pagy, @transactions = pagy(@transactions)
  end

  private

  def transaction_params
    params.permit(:transaction_type, :user_id, :stock_id)
  end

end
