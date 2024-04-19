# $ bundle exec rspec spec/features/admin/admin_4_list_traders.rb
require 'rails_helper'

RSpec.describe 'List all traders', type: :feature do
  scenario 'Admin views all the traders' do
    admin = create(:user, :admin)
    trader1 = create(:user, :trader)
    trader2 = create(:user, :trader)
    trader3 = create(:user, :trader)

    sign_in admin

    visit admin_users_path

    within("tbody") do
      expect(page).to have_content(trader1.username)
      expect(page).to have_content(trader2.username)
      expect(page).to have_content(trader3.username)
    end
  end
end
