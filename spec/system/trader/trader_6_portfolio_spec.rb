# $ bundle exec rspec spec/features/trader/trader_6_portfolio_spec.rb
require 'rails_helper'

RSpec.describe 'Check portfolio page', type: :system do
  scenario 'Trader checks portfolio page' do
    trader = create(:user, :trader, :approved, :with_balance)
    buy_stock = create(:stock)
    buy_transaction = create(:transaction, :stock_goog, user: trader, stock: buy_stock)

    sign_in trader
    visit trader_dashboard_path

    # check trader status
    within('.profile-box') do
      expect(page).to have_text('All-access')
    end

    # Visit portfolio page
    visit trader_portfolio_path
    within('tbody') do
      expect(page).to have_content(buy_stock.stock_symbol)
      expect(page).to have_content(buy_stock.company_name)
      expect(page).to have_content(buy_transaction.shares)
    end
  end
end
