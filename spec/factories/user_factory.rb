FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    lastname { Faker::Name.last_name }
    country { 'VE' }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end