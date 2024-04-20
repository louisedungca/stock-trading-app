# $ bundle exec rspec spec/features/trader/trader_4_receive_confirmation_email_spec.rb
require 'rails_helper'

RSpec.describe 'Receive approval', type: :feature do
  scenario 'Trader receives app approval' do
    admin = create(:user, :admin)
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

    within(".profile-box") do
      expect(page).to have_content(trader[:username])
      expect(page).to have_content("Pending Approval")
    end

    expect(page).to have_content("We're currently evaluating your account.")
    expect(page).to have_content('Kindly wait for the confirmation email regarding the status of your account.')
    expect(page).to have_content('You can browse through the market page in the meantime.')

    visit destroy_user_session_path

    # Admin Side Approval
    sign_in admin
    visit admin_dashboard_path
    within(".header") do
      expect(page).to have_text("Admin")
    end

    within(".pending-approvals") do # using scope to make sure that the trader is under pending box
      expect(page).to have_content(trader[:email])

      approve_button = find(".approve-btn", match: :first)
      approve_button.click
    end

    # Check if email is sent/received
    expect(ActionMailer::Base.deliveries.count).to eq(2)
    email = ActionMailer::Base.deliveries.last
    expect(email.to).to eq([trader[:email]])
    expect(email.subject).to eq("You're Approved! Let's Start Trading with Stocker!")

    sign_out admin
    visit new_user_session_path
    click_on 'Login'
    fill_in 'user[login]', with: trader[:email]
    fill_in 'user[password]', with: trader[:password]
    click_on 'Login'

    within(".profile-box") do
      expect(page).to have_content(trader[:username])
      expect(page).to have_content("All-access")
    end

  end
end
