class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_enum :transaction_type, %w[buy sell cash_in]
    create_table :transactions do |t|
      t.enum :transaction_type, enum_type: 'transaction_type'
      t.decimal :shares
      t.decimal :price_per_share
      t.references :user, null: false, foreign_key: true
      t.references :stock, foreign_key: true
      t.decimal :amount
      t.timestamps
    end
  end
end
