FactoryBot.define do
  factory :project_comment do
    comment { Faker::Lorem.characters(number:120) }
    user
    project
  end
end