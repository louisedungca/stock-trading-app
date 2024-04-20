FactoryBot.define do
  factory :stock do
    stock_symbol { "GOOG" }
    company_name { "Alphabet Inc - Class C" }
    logo_url { "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/GOOG.png" }
    sequence(:id) { |n| n+1 }

    trait :aapl do
      stock_symbol { "AAPL"}
      company_name { "Apple Inc" }
      logo_url { "https://storage.googleapis.com/iexcloud-hl37opg/api/logos/AAPL.png" }
    end

  end
end
