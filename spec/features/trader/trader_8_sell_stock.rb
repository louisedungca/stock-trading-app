# $ bundle exec rspec spec/features/trader/trader_8_sell_stock.rb
require 'rails_helper'

RSpec.describe 'Sell Stock', type: :feature do
  scenario 'Trader sells stock' do
    trader = create(:user, :trader, :approved, :with_balance)
    stock_symbol = 'GOOG'
    buy_shares = 3.0
    sell_shares = 1.0

    sign_in trader
    visit trader_dashboard_path

    # check trader status
    within(".profile-box") do
      expect(page).to have_text("All-access")
    end

    # buy stocks
    visit trader_trade_path
    expect(page).to have_content('Trade Stocks')
    fill_in 'stock_symbol', with: stock_symbol
    click_on 'Search', wait: 5

    within(".buy-form") do
      fill_in 'buy_shares', with: buy_shares
      click_on 'Buy'
    end

    visit trader_portfolio_path
    within("tbody") do
      expect(page).to have_content(stock_symbol)
      expect(page).to have_content(buy_shares)
      click_on "BUY/SELL"
    end

    expect(page).to have_content('Trade Stocks')
    within(".sell-form") do
      fill_in 'sell_shares', with: sell_shares
      click_on 'Sell'
    end

    expect(page).to have_content("#{stock_symbol} stock sold successfully")
  end
end
