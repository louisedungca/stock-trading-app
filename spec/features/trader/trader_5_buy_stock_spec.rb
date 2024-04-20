# $ bundle exec rspec spec/features/trader/trader_5_buy_stock_spec.rb
require 'rails_helper'

RSpec.describe 'Buy Stock', type: :feature do
  scenario 'Trader buys stock' do
    trader = create(:user, :trader, :approved, :with_balance)
    stock_symbol = 'GOOG'
    shares = '1.0'

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
      fill_in 'buy_shares', with: shares
      click_on 'Buy'
    end

    expect(page).to have_content("#{stock_symbol} stock purchased successfully")

  end
end
