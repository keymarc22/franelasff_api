FactoryBot.define do
  factory :store do
    name { Faker::Commerce.department }
    location { Faker::Address.street_address }
    owner { association :user }

    trait :with_shirts do
      after(:create) do |store|
        5.times { create :shirt, store_id: store.id }
      end
    end
  end
end