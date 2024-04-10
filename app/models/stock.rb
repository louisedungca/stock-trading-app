# == Schema Information
#
# Table name: stocks
#
#  id           :bigint           not null, primary key
#  logo_url     :string
#  shares       :decimal(, )
#  stock_symbol :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_stocks_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Stock < ApplicationRecord
  belongs_to :user
end
