# == Schema Information
#
# Table name: transactions
#
#  id               :bigint           not null, primary key
#  amount           :decimal(, )
#  price_per_share  :decimal(, )
#  shares           :decimal(, )
#  transaction_type :enum
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  stock_id         :bigint
#  user_id          :bigint           not null
#
# Indexes
#
#  index_transactions_on_stock_id  (stock_id)
#  index_transactions_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (stock_id => stocks.id)
#  fk_rails_...  (user_id => users.id)
#
class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :stock, optional: true

  validates :transaction_type, presence: true
  validates :shares, numericality: { greater_than: 0 }, if: -> { shares.present? }
  validates :amount, numericality: { greater_than: 0 }, if: -> { amount.present? }

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

  def self.buy_shares(user, stock_symbol, shares)
    stock = IEX::Api::Client.new.quote(stock_symbol)
    logo = IEX::Api::Client.new.logo(stock_symbol)
    total_cost = stock.latest_price * shares
    target_stock = user.stocks.where(stock_symbol: stock_symbol).first_or_initialize
    target_stock.update!(
      stock_symbol: stock_symbol,
      logo_url: logo.url,
      company_name: stock.company_name
    )

    transaction do
      if user.balance < total_cost
        errors.add('Insufficient account balance.')
        raise ActiveRecord::Rollback
      end

      user.transactions.create!(
        transaction_type: 'buy',
        shares:,
        price_per_share: stock.latest_price,
        user_id: user.id,
        stock_id: target_stock.id
      )
      user.update(balance: user.balance - total_cost)
    end
  rescue ActiveRecord::RecordInvalid
    errors.add(:base, "Failed to buy #{stock.symbol} shares.")
    false
  end

  # def self.cash_in(user, amount)
  #   return unless amount.positive?

  #   transaction do
  #     user.balance += amount
  #     save!

  #     transactions.create!(transaction_type: 'cash_in', amount:)
  #   end
  # rescue ActiveRecord::RecordInvalid
  #   errors.add(:base, 'Failed to cash-in money.')
  #   false
  # end
end
