FactoryBot.define do
  factory :department do
    name { Faker::Lorem.characters(number:10) }
  end
end