FactoryBot.define do
  factory :project do
    name { Faker::Lorem.characters(number: 10) }
    start_date { Faker::Date.between(from: '2022-04-01', to: '2023-03-31') }
    end_date { Faker::Date.between(from: '2023-04-01', to: '2024-03-31') }
    introduction { Faker::Lorem.characters(number: 140) }
    contract_amount { Faker::Lorem.characters(number: 10) }
    company
    user
  end
end