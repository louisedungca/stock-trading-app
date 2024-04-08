# == Schema Information
#
# Table name: transactions
#
#  id              :bigint           not null, primary key
#  company_name    :string
#  price_per_share :decimal(, )
#  shares          :decimal(, )
#  stock_symbol    :string
#  type            :enum
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
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
end
