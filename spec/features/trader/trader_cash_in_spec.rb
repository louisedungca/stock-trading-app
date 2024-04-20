# $ bundle exec rspec spec/features/trader/trader_cash_in_spec.rb
require 'rails_helper'

RSpec.describe 'Cash-in Transaction', type: :feature do
  scenario 'Trader creates a cash-in transaction' do
    trader = create(:user, :trader, :approved)
    amount = 2000.25

    sign_in trader
    visit trader_dashboard_path

    # check trader status
    within(".profile-box") do
      expect(page).to have_text("All-access")
    end

    within(".balance-box") do
      button = find(".cash-in-btn")
      button.click
    end

    within(".form__wrapper") do
      fill_in 'Cash-in Amount', with: amount
      click_on 'Cash-in'
    end

    expect(page).to have_content("Successfully cashed in #{format_currency(amount, unit: '$')}.")

  end
end
