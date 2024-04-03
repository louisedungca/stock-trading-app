class AddUidToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :uid, :string
    add_index :users, :uid, :unique => true
  end
end


# Usage:
# user = User.create(email: "foo@bar.com")
# puts user.uid # => "V8aS9tucNzKyH39d4Bpq"
