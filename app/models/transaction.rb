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

  TRANSACTION_TYPES = Transaction.transaction_types.keys # => ["buy", "sell", "cash_in", "withdraw"]

  scope :filter_by_type, ->(filter) {
    if TRANSACTION_TYPES.include?(filter)
      where(transaction_type: filter)
    else
      all
    end
  }

  def self.ransackable_attributes(auth_object = nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object = nil)
    authorizable_ransackable_associations
  end

  def self.buy_shares(user, stock_symbol, shares)
    return unless shares.present?

    stock = IEX::Api::Client.new.quote(stock_symbol)
    total_cost = stock.latest_price * shares
    logo = IEX::Api::Client.new.logo(stock_symbol)
    target_stock = Stock.where(stock_symbol: stock_symbol).first_or_initialize
    target_stock.update!(
      stock_symbol: stock_symbol.upcase,
      logo_url: logo.url,
      company_name: stock.company_name
    )

    transaction do
      if user.balance <= 0
        # Rails.logger.info("BUY ERROR: 0 balance.") # for checking logs only
        user.errors.add(:base, "You do not have any balance in your account. Please cash in.")
        raise ActiveRecord::Rollback
      elsif  user.balance < total_cost
        # Rails.logger.info("BUY ERROR: Insufficient balance.") # for checking logs only
        user.errors.add(:base, "Insufficient balance to proceed with this transaction.")
        raise ActiveRecord::Rollback
      end

      user.update!(balance: user.balance - total_cost)
      user.transactions.create!(
        transaction_type: 'buy',
        shares:,
        price_per_share: stock.latest_price,
        amount: total_cost,
        user_id: user.id,
        stock_id: target_stock.id
      )
    end

  rescue ActiveRecord::RecordInvalid
    user.errors.add(:base, "Error in buying #{stock_symbol} shares")
    false
  end

  def self.sell_shares(user, stock_symbol, shares)
    stock = IEX::Api::Client.new.quote(stock_symbol)
    total_cost = stock.latest_price * shares
    target_stock = Stock.find_by(stock_symbol: stock_symbol)
    total_shares = target_stock.total_shares(user)

    transaction do
      if total_shares < shares
        # Rails.logger.info("SELL ERROR: Insufficient shares.") # for checking logs only
        user.errors.add(:base, "Not enough shares to proceed with this transaction.")
        raise ActiveRecord::Rollback
      end

      user.update!(balance: user.balance + total_cost)
      user.transactions.create!(
        transaction_type: 'sell',
        shares:,
        price_per_share: stock.latest_price,
        user_id: user.id,
        stock_id: target_stock.id
      )
    end

  rescue ActiveRecord::RecordInvalid
    user.errors.add(:base, "Error in selling #{stock_symbol} shares")
    false
  end

  def self.cash_in(user, amount)
    return unless amount.positive?

    transaction do
      user.update(balance: user.balance + amount)

      user.transactions.create!(
        transaction_type: 'cash_in',
        amount:
        )
    end

  rescue ActiveRecord::RecordInvalid
    user.errors.add(:base, "Failed to cash in money. Please try again.")
    false
  end

  def self.withdraw(user, amount)
    return unless amount.positive?

    transaction do
      if user.balance < amount
        user.errors.add(:base, "Insufficient balance for cash out.")
        raise ActiveRecord::Rollback
      end

      user.update(balance: user.balance - amount)

      user.transactions.create!(
        transaction_type: 'withdraw',
        amount:
        )
    end

  rescue ActiveRecord::RecordInvalid
    user.errors.add(:base, "Failed to cash out money. Please try again.")
    false
  end
end
