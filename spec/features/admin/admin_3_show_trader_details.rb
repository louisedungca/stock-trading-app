# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Show a trader', type: :feature do
  scenario 'Admin views the trader details' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader1 = create(:user, :trader) # create admin (using FactoryBot methods)

    sign_in admin
    visit admin_root_path
    expect(page).to have_content('Good morning, Admin' || 'Good evening, Admin')

    visit admin_users_path
    show_button = find("a[data-turbo-frame='show_modal']")
    show_button.click

    # Check if user details is present
    expect(page).to have_content('User Details')
  end
end
