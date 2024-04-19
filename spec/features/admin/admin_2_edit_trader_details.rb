# $ bundle exec rspec spec/features/admin/admin_2_edit_trader_details.rb
require 'rails_helper'

RSpec.describe 'Editing a trader', type: :feature do
  scenario 'Admin edits trader details' do
    admin = create(:user, :admin)
    trader_1 = create(:user, :trader)

    sign_in admin

    visit admin_root_path
    expect(page).to have_content("Good morning, Admin" || "Good evening, Admin" || "Good afternoon, Admin")

    visit admin_users_path
    expect(page).to have_content("All Traders")

    within("tbody") do
      expect(page).to have_content(trader_1.username)
    end

    within(".modal-btns") do
      edit_button = find(".edit-btn")
      edit_button.click
    end

    expect(page).to have_content("Edit User Details")

    new_username = "#{trader_1.username}_edited"
    fill_in "user[username]", with: new_username
    click_button "Save Changes"

    visit admin_users_path
    expect(page).to have_content("All Traders")

    # save_and_open_page # for inspecting only

    within("tbody") do
      expect(page).to have_content(new_username)
    end
  end
end
