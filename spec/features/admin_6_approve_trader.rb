# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Approve traders', type: :feature do
  scenario 'Admin approve pending traders' do
    admin = create(:user, :admin) # create admin (using FactoryBot methods)
    trader1 = create(:user, :trader)

    # Check Verification Email
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([trader1.email])
    expect(email.subject).to eq('Confirmation instructions')
    # Click the verification link
    user = User.find_by(email: trader1.email)
    visit user_confirmation_path(confirmation_token: user.confirmation_token)

    sign_in admin

    visit root_path
    visit admin_root_path

    # Check if trader1 is waiting for approval
    expect(page).to have_content(trader1.email)
  end
end
