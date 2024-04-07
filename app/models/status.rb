# == Schema Information
#
# Table name: statuses
#
#  id          :bigint           not null, primary key
#  status_type :enum             default("pending"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_statuses_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Status < ApplicationRecord
  belongs_to :user

  enum :status_type, {
    pending: "pending",
    approved: "approved",
    confirmed_email: "confirmed_email",
  }, default: "pending"
end
