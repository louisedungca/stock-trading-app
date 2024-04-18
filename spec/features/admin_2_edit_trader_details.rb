# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Editing a trader', type: :feature do
  scenario 'Admin edits the trader details' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader1 = create(:user, :trader) # create admin (using FactoryBot methods)
    # trader2 = create(:user, :trader) # create admin (using FactoryBot methods)
    sign_in admin # sign in as admin (using Devise Test Integration helper)

    visit root_path
    visit admin_users_path
    visit edit_admin_user_path(trader1)

    trader_username = 'change_to'
    fill_in 'user[username]', with: trader_username
    click_on 'Save Changes'

    visit admin_users_path
    expect(page).to have_content(trader_username)
  end
end
