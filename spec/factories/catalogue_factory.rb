FactoryBot.define do
  factory :catalogue do
    title { Faker::Lorem.sentence(word_count: 5) }
    description { Faker::Lorem.sentence(word_count: 30) }
    owner { association :user }

    trait :with_shirts do
      after(:create) do |catalogue|
        catalogue.shirts << create_list(:shirt, 5)
      end
    end
  end
end