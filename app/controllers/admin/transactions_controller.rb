class Admin::TransactionsController < ApplicationController
  layout 'dashboard_layout'

  def index
    @transactions = if params[:search].present?
                      Transaction.joins(:user)
                                 .where(users: { uid: params[:search] })
                                 .order(updated_at: :desc)
                                 .filter_by_type(params[:filter])
                    else
                      Transaction.order(updated_at: :desc).filter_by_type(params[:filter])
                    end

    @pagy, @transactions = pagy_array(@transactions) || pagy(@transactions)
  end
end
