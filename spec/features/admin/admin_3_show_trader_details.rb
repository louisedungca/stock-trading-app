# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Show a trader', type: :feature do
  scenario 'Admin views the trader details' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader1 = create(:user, :trader) # create admin (using FactoryBot methods)
    sign_in admin # sign in as admin (using Devise Test Integration helper)

    visit root_path
    visit admin_users_path
    visit admin_user_path(trader1)

    # Check if user details is present
    user_info = 'User Details'
    expect(page).to have_content(user_info)
  end
end
