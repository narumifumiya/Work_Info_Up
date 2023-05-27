FactoryBot.define do
  factory :chat do
    message { Faker::Lorem.characters(number: 140) }
    user
    group
  end
end