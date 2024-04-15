# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )
#  company_name     :string
#  price_per_share  :decimal(, )
#  shares           :decimal(, )
#  stock_symbol     :string
#  transaction_type :enum
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint           not null
#
# Indexes
#
#  index_transactions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Transaction < ApplicationRecord
  belongs_to :user

  enum :transaction_type, {
    buy: 'buy',
    sell: 'sell',
    cash_in: 'cash_in',
    withdraw: 'withdraw'
  }

  scope :filter_by_type, lambda { |filter|
    case filter
    when 'buy'
      where(transaction_type: 'buy')
    when 'sell'
      where(transaction_type: 'sell')
    when 'cash_in'
      where(transaction_type: 'cash_in')
    when 'withdraw'
      where(transaction_type: 'withdraw')
    else
      all
    end
  }
end
