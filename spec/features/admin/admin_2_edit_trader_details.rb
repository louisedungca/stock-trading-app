# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Editing a trader', type: :feature do
  scenario 'Admin edits the trader details' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader1 = create(:user, :trader) # create admin (using FactoryBot methods)

    sign_in admin
    visit admin_root_path
    expect(page).to have_content('Good morning, Admin' || 'Good evening, Admin')

    visit admin_users_path
    visit edit_admin_user_path(1)
    # find("a[href='#{edit_admin_user_path(1)}']").click
    expect(page).to have_content('Edit User Details')

    trader_username = 'change_to'
    fill_in 'user[username]', with: trader_username
    click_on 'Save Changes'

    visit admin_users_path
    expect(page).to have_content(trader_username)
  end
end
