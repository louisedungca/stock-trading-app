# $ bundle exec rspec spec/features/admin/admin_3_show_trader_details_spec.rb
require 'rails_helper'

RSpec.describe 'Show a trader', type: :system do
  scenario 'Admin displays trader details' do
    admin = create(:user, :admin)
    trader_1 = create(:user, :trader)

    sign_in admin

    visit admin_dashboard_path
    within('.header') do
      expect(page).to have_text('Admin')
    end

    visit admin_users_path
    expect(page).to have_content('All Traders')

    within('tbody') do
      expect(page).to have_content(trader_1.username)
    end

    within('.modal-btns') do
      info_button = find('.info-btn')
      info_button.click
    end

    expect(page).to have_content('User Details')
    expect(page).to have_content("Email: #{trader_1.email}")
  end
end
