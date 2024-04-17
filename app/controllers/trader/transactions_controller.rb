class Trader::TransactionsController < ApplicationController
  layout 'dashboard_layout'

  def index
    @transactions = current_user.transactions.filter_by_type(params[:filter]).order(updated_at: :desc).includes(:stock)
    @transaction_types = Transaction::TRANSACTION_TYPES
    @pagy, @transactions = pagy(@transactions)

    puts "TX_TYPES: #{@transaction_types}"
  end
end
