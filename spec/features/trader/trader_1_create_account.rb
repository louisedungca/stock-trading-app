# $ bundle exec rspec spec/features/invite_a_trader_spec.rb
require 'rails_helper'

RSpec.describe 'Create account', type: :feature do
  scenario 'Trader creates an account' do
    # Navigate to signup
    visit root_path
    click_on 'Get Started'
    fill_in 'Username', with: 'testing_account'
    fill_in 'Email', with: 'testing_account@email.com'
    fill_in 'Password', with: 'asdfasdf'
    fill_in 'Password confirmation', with: 'asdfasdf'
    click_on 'Register'
    expect(page).to have_content('Verify Your Email')
    expect(page).to have_content('Check your email and click the link to activate your account.')
  end
end
