FactoryBot.define do
  factory :customer do
    name { Faker::Lorem.characters(number: 10) }
    phone_number { Faker::Lorem.characters(number:10) }
    email { Faker::Internet.email }
    position { Faker::Lorem.characters(number: 10) }
    department { Faker::Lorem.characters(number: 10) }
    company
  end
end