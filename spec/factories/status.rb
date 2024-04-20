FactoryBot.define do
  factory :status do
    status_type { "pending" }

    trait :confirmed_email do
      status_type { "confirmed_email" }
    end

    trait :approved do
      status_type { "approved" }
    end
  end
end
