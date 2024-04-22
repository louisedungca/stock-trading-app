# $ bundle exec rspec spec/features/trader/trader_7_transaction_spec.rb
require 'rails_helper'

RSpec.describe 'Check transaction page', type: :system do
  scenario 'Trader checks transaction page for transactions history' do
    trader = create(:user, :trader, :approved, :with_balance)
    buy_stock = create(:stock)
    sell_stock = create(:stock, :aapl)

    buy_transaction = create(:transaction, :stock_goog, user: trader, stock: buy_stock)
    buy_transaction = create(:transaction, :stock_aapl, user: trader, stock: buy_stock)
    cash_in_transaction = create(:transaction, user: trader)
    sell_transaction = create(:transaction, :stock_aapl, user: trader, stock: sell_stock)
    withdraw_transaction = create(:transaction, :withdraw, user: trader)

    sign_in trader
    visit trader_dashboard_path

    # check trader status
    within('.profile-box') do
      expect(page).to have_text('All-access')
    end

    # Transaction Page
    visit trader_transactions_path
    within('tbody') do
      expect(page).to have_content('CASH_IN')
      expect(page).to have_content('BUY')
      expect(page).to have_content('SELL')
      expect(page).to have_content('WITHDRAW')
      expect(page).to have_content('GOOG')
      expect(page).to have_content('AAPL')
    end
  end
end
