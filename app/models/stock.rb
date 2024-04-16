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

  def total_shares
    buy = transactions.where(transaction_type: 'buy').sum(:shares).to_f
    sell = transactions.where(transaction_type: 'sell').sum(:shares).to_f
    buy - sell
  end
end
