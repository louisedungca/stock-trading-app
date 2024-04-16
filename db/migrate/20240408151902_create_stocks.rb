class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :stock_symbol
      t.string :logo_url
      t.string :company_name

      t.timestamps
    end
  end
end
