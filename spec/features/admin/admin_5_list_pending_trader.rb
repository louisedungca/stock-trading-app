# $ bundle exec rspec spec/features/admin/admin_5_list_pending_trader.rb
require 'rails_helper'

RSpec.describe 'See pending traders', type: :feature do
  scenario 'Admin views all pending traders' do
    confirmed_trader_1 = create(:user, :trader, :confirmed_email)
    confirmed_trader_2 = create(:user, :trader, :confirmed_email)
    admin = create(:user, :admin)

    sign_in admin
    visit admin_dashboard_path
    within(".header") do
      expect(page).to have_text("Admin")
    end

    # Check if trader is pending
    within(".pending-approvals") do
      expect(page).to have_content(confirmed_trader_1.email)
      expect(page).to have_content(confirmed_trader_2.email)
    end
  end
end
