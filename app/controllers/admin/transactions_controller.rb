class Admin::TransactionsController < AdminsController
  layout 'dashboard_layout'

  def index
    @transactions = if params[:search].present?
                      Transaction.joins(:user)
                                 .where(users: { uid: params[:search] })
                                 .order(updated_at: :desc)
                    else
                      Transaction.order(updated_at: :desc)
                    end


    @transactions = @transactions.filter_by_type(params[:filter])
    @transaction_types = Transaction::TRANSACTION_TYPES
    @pagy, @transactions = pagy(@transactions)
  end
end
