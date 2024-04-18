# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'See trader transactions', type: :feature do
  scenario 'Admin sees all transactions' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    sign_in admin # sign in as admin (using Devise Test Integration helper)

    visit root_path
    visit admin_transactions_path

    # Check transactions table
    expect(page).to have_content("Trader Transaction")
  end
end
