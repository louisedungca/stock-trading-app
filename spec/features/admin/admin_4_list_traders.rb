# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'List all traders', type: :feature do
  scenario 'Admin views all the traders' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader1 = create(:user, :trader)
    trader2 = create(:user, :trader)
    trader3 = create(:user, :trader)
    sign_in admin # sign in as admin (using Devise Test Integration helper)

    visit root_path
    visit admin_users_path

    expect(page).to have_content(trader1.username)
    expect(page).to have_content(trader2.username)
    expect(page).to have_content(trader3.username)
  end
end
