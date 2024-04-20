class Admin::TransactionsController < AdminsController
  # before_action :transaction_params
  layout 'admin_layout'

  def index
    @q = Transaction.includes(:user, :stock).ransack(params[:q])
    @transactions = @q.result(distinct: true)

    if params[:q].present? && @transactions.empty?
      flash[:alert] = "Hmm. Please try searching for something else."
      redirect_to admin_transactions_path
    end

    if params[:filter].present? && Transaction::TRANSACTION_TYPES.include?(params[:filter])
      @traders = Transaction.includes(:user, :stock).where(transaction_type: params[:filter])
    end

    @transactions = @transactions.filter_by_type(params[:filter])
    @transaction_types = Transaction::TRANSACTION_TYPES
    @pagy, @transactions = pagy(@transactions)
  end

end
