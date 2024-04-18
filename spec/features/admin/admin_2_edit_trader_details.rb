# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Editing a trader', type: :feature do
  scenario 'Admin edits the trader details' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader = create(:user, :trader) # create admin (using FactoryBot methods)

    sign_in admin
    visit admin_root_path
    expect(page).to have_content('Good morning, Admin' || 'Good evening, Admin')

    visit admin_users_path
    edit_button = find("a[data-turbo-frame='edit_modal']")
    edit_button.click
    expect(page).to have_content('Edit User Details')

    new_trader_username = 'change_to'
    fill_in 'user[username]', with: new_trader_username
    click_on 'Save Changes'

    visit admin_users_path
    expect(page).to have_content(new_trader_username)
  end
end
