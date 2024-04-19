# $ bundle exec rspec spec/features/admin/admin_7_trader_transactions.rb
require 'rails_helper'

RSpec.describe 'See trader transactions', type: :feature do
  scenario 'Admin sees all transactions' do
    trader_1 = create(:user, :trader)
    trader_2 = create(:user, :trader)
    admin = create(:user, :admin)

    buy_stock = create(:stock)
    sell_stock = create(:stock, :aapl)
    cash_in_transaction = create(:transaction, user: trader_1)
    buy_transaction = create(:transaction, :stock_goog, user: trader_1, stock: buy_stock)
    sell_transaction = create(:transaction, :stock_aapl, user: trader_1, stock: sell_stock)
    withdraw_transaction = create(:transaction, :withdraw, user: trader_1)

    sign_in admin
    visit admin_dashboard_path
    within(".header") do
      expect(page).to have_text("Admin")
    end

    visit admin_transactions_path
    expect(page).to have_content('Traders Transactions')

    # Check transactions table
    within("tbody") do
      expect(page).to have_content('CASH_IN')
      expect(page).to have_content('BUY')
      expect(page).to have_content('SELL')
      expect(page).to have_content('WITHDRAW')
    end

  end
end
