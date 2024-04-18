# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require "rails_helper"

RSpec.describe 'Inviting a trader', type: :feature do
  scenario 'Admin invites a new trader' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    sign_in admin # sign in as admin (using Devise Test Integration helper)

    visit root_path

    trader_email = "trader_1@test.com"
    fill_in "Email", with: trader_email
    click_on "Send an invitation"

    visit admin_users_path
    expect(page).to have_content(trader_email)
  end
end
