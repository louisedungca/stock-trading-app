# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'See pending traders', type: :feature do
  scenario 'Admin views all pending traders' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader1 = create(:user, :trader)
    trader2 = create(:user, :trader)
    trader3 = create(:user, :trader)
    # trader2 = create(:user, :trader) # create admin (using FactoryBot methods)
    sign_in admin # sign in as admin (using Devise Test Integration helper)

    visit root_path
    visit admin_root_path

    # PASS MUNA SA LOGIC NG PAGVERIFY NG EMAIL

    expect(page).to have_content(trader1.email)
    expect(page).to have_content(trader2.email)
    expect(page).to have_content(trader3.email)
  end
end
