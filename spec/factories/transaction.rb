FactoryBot.define do
  factory :transaction do
    transaction_type { "cash_in" }
    shares { nil }
    price_per_share { nil }
    user
    stock { nil }
    amount { 10000.0 }

    trait :withdraw do
      transaction_type { "withdraw" }
      amount { 250.0 }
    end

    trait :stock_goog do
      transaction_type { "buy" }
      price_per_share { 100.0 }
      shares { 2 }
      stock
    end

    trait :stock_aapl do
      transaction_type { "sell" }
      price_per_share { 120.0 }
      shares { 3 }
      stock
    end
  end
end
