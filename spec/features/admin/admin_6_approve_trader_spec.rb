# $ bundle exec rspec spec/features/admin/admin_6_approve_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Approve traders', type: :feature do
  scenario 'Admin approve pending traders' do
    confirmed_trader_1 = create(:user, :trader, :confirmed_email)
    confirmed_trader_2 = create(:user, :trader, :confirmed_email)
    admin = create(:user, :admin)

    sign_in admin
    visit admin_dashboard_path
    within(".header") do
      expect(page).to have_text("Admin")
    end

    # Check if trader is pending
    within(".pending-approvals") do # using scope to make sure that the trader is under pending box
      expect(page).to have_content(confirmed_trader_1.email)
      expect(page).to have_content(confirmed_trader_2.email)

      approve_button = find(".approve-btn", match: :first)
      approve_button.click
    end

    visit admin_dashboard_path

    # Check if trader_1 has been approved
    within(".pending-approvals") do
      expect(page).not_to have_content(confirmed_trader_1.email)
    end

    within(".recent-approvals") do # using scope to make sure that the trader is under approved box
      expect(page).to have_content(confirmed_trader_1.email)
    end
  end
end
