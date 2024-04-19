# $ bundle exec rspec spec/features/admin/admin_7_trader_transactions.rb
require 'rails_helper'

RSpec.describe 'See trader transactions', type: :feature do
  scenario 'Admin sees all transactions' do
    admin = create(:user, :admin)
    sign_in admin

    visit admin_transactions_path

    # Check transactions table
    expect(page).to have_content('Traders Transactions')
  end
end
