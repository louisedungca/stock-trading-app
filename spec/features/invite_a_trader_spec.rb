require "rails_helper"

RSpec.describe 'Inviting a trader', type: :feature do
  scenario 'Admin invites a new trader' do
    admin = User.create!(
      email: "admin@email.com",
      username: "admin00",
      password: "111111",
      password_confirmation: "111111",
      role: "admin",
      confirmed_at: Time.current
    )

    sign_in admin

    visit root_path
    fill_in "Email", with: "trader_1@test.com"
    click_on "Send an invitation"

    visit admin_users_path
    expect(page).to have_content("trader_1@test.com")
  end
end
