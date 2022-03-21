FactoryBot.define do
  factory :shirt do
    name { Faker::Commerce.department }
    location { Faker::Address.street_address }

    trait :with_shirts do
      after(:create) do |store|
        create :shirt, store_id: store.id
      end
    end
  end
end