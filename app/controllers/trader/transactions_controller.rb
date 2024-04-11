class Trader::TransactionsController < ApplicationController
  layout 'dashboard_layout'

  def index
    @trader_status = current_user.status&.status_type
    @transactions = case params[:filter]
                    when 'buy'
                      current_user.transactions.where(transaction_type: 'buy')
                    when 'sell'
                      current_user.transactions.where(transaction_type: 'sell')
                    when 'cash_in'
                      current_user.transactions.where(transaction_type: 'cash_in')
                    else
                      current_user.transactions
                    end
    @pagy, @transactions = pagy_array(@transactions) || pagy(@transactions)
  end
end
