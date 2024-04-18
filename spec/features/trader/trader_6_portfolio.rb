# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Check portfolio page', type: :feature do
  scenario 'Trader checks portfolio page' do
    trader = {
      username: 'testing_account',
      email: 'testing_account@email.com',
      password: 'asdfasdf'
    }
    admin = create(:user, :admin)

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
    fill_in 'user[login]', with: trader[:email]
    fill_in 'user[password]', with: trader[:password]
    click_on 'Login'

    expect(page).to have_content("We're currently evaluating your account.")
    expect(page).to have_content('Kindly wait for the confirmation email regarding the status of your account.')
    expect(page).to have_content('You can browse through the market page in the meantime.')
    visit destroy_user_registration_path

    # Admin Side Approval
    sign_in admin
    visit admin_root_path
    click_on 'Approve'

    # Check if email is sent/received
    expect(ActionMailer::Base.deliveries.count).to eq(2)
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([trader[:email]])
    expect(email.subject).to eq("You're Approved! Let's Start Trading with Stocker!")

    # Admin Logout
    sign_out admin

    # Login approved user
    visit new_user_session_path
    expect(page).to have_content('Sign in')
    fill_in 'user[login]', with: trader[:email]
    fill_in 'user[password]', with: trader[:password]
    click_on 'Login'

    # Cash in
    click_on 'Cash-in'
    fill_in 'amount', with: '10000'
    click_on 'Cash-in'
    expect(page).to have_content('10,000.00')

    # Buy stock
    click_on 'Trade'
    expect(page).to have_content('Trade Stocks')
    fill_in 'stock_symbol', with: 'GOOG'
    click_on 'Search', wait: 3
    fill_in 'buy_shares', with: '1'
    click_on 'Buy'

    # Visit portfolio page
    visit trader_portfolio_path
    expect(page).to have_content('My Portfolio')
    expect(page).to have_content('GOOG')
    expect(page).to have_content('Alphabet Inc - Class C')
    expect(page).to have_content('SHARES')
  end
end
