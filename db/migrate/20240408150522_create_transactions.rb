class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_enum :type, %w[buy sell cash_in]
    create_table :transactions do |t|
      t.enum :type, enum_type: 'type'
      t.decimal :shares
      t.string :stock_symbol
      t.string :company_name
      t.decimal :price_per_share
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
