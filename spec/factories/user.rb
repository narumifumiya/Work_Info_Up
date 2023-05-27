FactoryBot.define do
  factory :user do
    name { Faker::Lorem.characters(number:10) }
    name_kana { Faker::Lorem.characters(number:20) }
    phone_number { Faker::Lorem.characters(number:10) }
    email { Faker::Internet.email }
    position { Faker::Lorem.characters(number:10) }
    password { "password" }
    password_confirmation { "password" }
    department
  end
end