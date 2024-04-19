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
  end
end


# USAGE
## Create an admin user
# admin_user = create(:user, :admin)

# # Create two trader users
# trader_1 = create(:user, :trader)
# trader_2 = create(:user, :trader)
