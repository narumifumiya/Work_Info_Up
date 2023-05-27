FactoryBot.define do
  factory :office do
    name { Faker::Lorem.characters(number: 10) }
    post_code { Faker::Lorem.characters(number: 10) }
    address { Faker::Lorem.characters(number: 20) }
    phone_number { Faker::Lorem.characters(number:10) }
    company
  end
end