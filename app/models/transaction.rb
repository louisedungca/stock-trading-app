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
  # validate :valid_shares_for_transaction_type

  # def valid_shares_for_transaction_type
  #   unless %w[buy sell].include?(transaction_type)
  #     errors.add(:transaction_type, "must be 'buy' or 'sell'")
  #     return
  #   end

  #   if transaction_type == 'buy' && shares < 0
  #     errors.add(:shares, "must be non-negative for 'buy' transactions")
  #   elsif transaction_type == 'sell' && shares >= 0
  #     errors.add(:shares, "must be negative for 'sell' transactions")
  #   end
  # end

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
    total_cost = stock.latest_price * shares
    existing_stock = user.stocks.find_by(stock_symbol:)

    return unless shares.positive? && user.balance > total_cost

    transaction do
      if existing_stock.present?
        user.transactions.create!(
          transaction_type: 'buy',
          shares:,
          price_per_share: stock.latest_price,
          stock_id: existing_stock.id
        )
      else
        logo = IEX::Api::Client.new.logo(stock_symbol)
        new_stock = Stock.create!(
          stock_symbol:,
          logo_url: logo.url,
          company_name: stock.company_name
        )
        new_stock.transactions.create!(
          user_id: user.id,
          transaction_type: 'buy',
          shares:,
          price_per_share: stock.latest_price
        )
      end
      user.update(balance: user.balance - total_cost)
    rescue ActiveRecord::RecordInvalid
      errors.add(:base, "Failed to buy #{stock.symbol} shares.")
      false
    end
  end

  def self.cash_in(user, amount)
    return unless amount.positive?

    transaction do
      user.balance += amount
      save!

      transactions.create!(transaction_type: 'cash_in', amount:)
    end
  rescue ActiveRecord::RecordInvalid
    errors.add(:base, 'Failed to cash-in money.')
    false
  end
end
