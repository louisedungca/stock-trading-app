class Trader::TransactionsController < ApplicationController
  layout 'dashboard_layout'

  def index
    @transactions = case params[:filter]
                    when 'buy'
                      current_user.transactions.where(transaction_type: 'buy').order(updated_at: :desc).includes(:stock)
                    when 'sell'
                      current_user.transactions.where(transaction_type: 'sell').order(updated_at: :desc).includes(:stock)
                    when 'cash_in'
                      current_user.transactions.where(transaction_type: 'cash_in').order(updated_at: :desc).includes(:stock)
                    else
                      current_user.transactions.order(updated_at: :desc).includes(:stock)
                    end
    @pagy, @transactions = pagy_array(@transactions) || pagy(@transactions)
  end
end
