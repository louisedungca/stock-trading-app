class Admin::TransactionsController < ApplicationController
  layout 'dashboard_layout'

  def index
    @transactions = if params[:search].present?
                      Transaction.joins(:user)
                                 .where(users: { uid: params[:search] })
                                 .filter_by_type(params[:filter])
                    else
                      Transaction.filter_by_type(params[:filter])
                    end

    @pagy, @transactions = pagy_array(@transactions) || pagy(@transactions)
  end
end
