# $ bundle exec rspec spec/features/trader/trader_withdraw_spec.rb
require 'rails_helper'

RSpec.describe 'Withdraw Transaction', type: :system do
  scenario 'Trader creates a cash-out transaction' do
    trader = create(:user, :trader, :approved, :with_balance)
    amount = 150.75

    sign_in trader
    visit trader_dashboard_path

    # check trader status
    within('.profile-box') do
      expect(page).to have_text('All-access')
    end

    within('.balance-box') do
      button = find('.withdraw-btn')
      button.click
    end

    within('.form__wrapper') do
      fill_in 'Cash-Out Amount', with: amount
      click_on 'Withdraw'
    end

    expect(page).to have_content("Successfully cashed out #{format_currency(amount, unit: '$')}.")

    # save_and_open_page # for inspecting only
  end
end
