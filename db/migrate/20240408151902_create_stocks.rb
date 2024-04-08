class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :stock_symbol
      t.decimal :shares
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
