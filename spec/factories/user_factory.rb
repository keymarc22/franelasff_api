FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    auth_token { Faker::Lorem.characters }
  end
end