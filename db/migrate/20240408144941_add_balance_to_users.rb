class AddBalanceToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :balance, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
