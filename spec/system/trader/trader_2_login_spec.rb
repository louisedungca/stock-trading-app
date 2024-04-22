# $ bundle exec rspec spec/features/trader/trader_2_login_spec.rb
require 'rails_helper'

RSpec.describe 'Log in account', type: :system do
  scenario 'Trader logs into the app' do
    trader = {
      username: 'testing_account',
      email: 'testing_account@email.com',
      password: 'asdfasdf'
    }

    # Navigate to signup
    visit root_path
    click_on 'Get Started'
    fill_in 'Username', with: trader[:username]
    fill_in 'Email', with: trader[:email]
    fill_in 'Password', with: trader[:password]
    fill_in 'Password confirmation', with: trader[:password]
    click_on 'Register'
    expect(page).to have_content('Verify Your Email')
    expect(page).to have_content('Check your email and click the link to activate your account.')

    # Mail Verification
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([trader[:email]])
    expect(email.subject).to eq('Confirmation instructions')
    # Click the verification link
    user = User.find_by(email: trader[:email])
    visit user_confirmation_path(confirmation_token: user.confirmation_token)

    # Login
    visit new_user_session_path
    click_on 'Login'
    fill_in 'user[login]', with: trader[:email]
    fill_in 'user[password]', with: trader[:password]
    click_on 'Login'

    # Check if trader is in dashboard
    expect(page).to have_content("We're currently evaluating your account.")
    expect(page).to have_content('Kindly wait for the confirmation email regarding the status of your account.')
    expect(page).to have_content('You can browse through the market page in the meantime.')
  end
end
