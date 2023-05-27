FactoryBot.define do
  # before do
  #   user = FactoryBot.create(:user)
  # end
  
  factory :group do
    name { Faker::Lorem.characters(number: 10) }
    introduction { Faker::Lorem.characters(number: 20) }
    # owner_id { user.id}
  end
end