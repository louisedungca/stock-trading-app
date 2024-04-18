# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'See trader transactions', type: :feature do
  scenario 'Admin sees all transactions' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader1 = create(:user, :trader)
    trader2 = create(:user, :trader)
    trader3 = create(:user, :trader)
    # trader2 = create(:user, :trader) # create admin (using FactoryBot methods)
    sign_in admin # sign in as admin (using Devise Test Integration helper)

    visit root_path
    visit admin_transactions_path
  end
end
