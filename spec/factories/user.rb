FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@email.com" }
    sequence(:username) { |n| "user_#{n}" }
    password { "111111" }
    password_confirmation { "111111" }
    sequence(:id) { |n| n+1 }

    trait :admin do
      email { "admin00@email.com" }
      username { "admin00" }
      role { "admin" }
      confirmed_at { Time.current }
    end

    trait :trader do
      sequence(:email) { |n| "trader_#{n}@email.com" }
      sequence(:username) { |n| "trader_#{n}" }
      role { "trader" }
    end

    trait :confirmed_email do
      after(:create) do |user|
        create(:status, :confirmed_email, user: user)
      end
    end

    trait :approved do
      after(:create) do |user|
        create(:status, :approved, user: user)
      end
    end
  end
end


# USAGE
## Create an admin user
# admin_user = create(:user, :admin)

# # Create two trader users
# trader_1 = create(:user, :trader)
# trader_2 = create(:user, :trader)

## Update status
# confirmed_trader = create(:user, :trader, :confirmed_email)
# approved_trader = create(:user, :trader, :approved)
