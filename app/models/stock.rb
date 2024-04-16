# == Schema Information
#
# Table name: stocks
#
#  id           :bigint           not null, primary key
#  company_name :string
#  logo_url     :string
#  stock_symbol :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Stock < ApplicationRecord
  has_many :transactions
  has_many :users, through: :transactions

  validates :stock_symbol, presence: true, uniqueness: { case_sensitive: false }
  validates :company_name, presence: true
  validates :logo_url, presence: true

  def self.group_similar_stocks(user)
    user.stocks
        .group_by(&:stock_symbol)
        .map do |stock_symbol, stocks|
          stock = stocks.first
          {
            stock_symbol: stock_symbol,
            logo_url: stock.logo_url,
            company_name: stock.company_name,
            total_shares: stock.total_shares(user)
          }
        end
  end

  def total_shares(user)
    buy = transactions.where(transaction_type: 'buy', user_id: user.id).sum(:shares).to_f
    sell = transactions.where(transaction_type: 'sell', user_id: user.id).sum(:shares).to_f
    buy - sell
  end
end
