class Admin::TransactionsController < ApplicationController
  layout 'dashboard_layout'

  def index
    @transactions = case params[:filter]
                    when 'buy'
                      Transaction.where(transaction_type: 'buy')
                    when 'sell'
                      Transaction.where(transaction_type: 'sell')
                    when 'cash_in'
                      Transaction.where(transaction_type: 'cash_in')
                    else
                      Transaction.all
                    end
    @pagy, @transactions = pagy_array(@transactions) || pagy(@transactions)
  end
end
