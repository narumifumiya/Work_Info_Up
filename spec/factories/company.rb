FactoryBot.define do
  factory :company do
    name { Faker::Lorem.characters(number:10) }
  end
end