FactoryBot.define do
  factory :catalogue do
    title { Faker::Lorem.sentence(word_count: 5) }
    title { Faker::Lorem.sentence(word_count: 30) }
    shirts
  end
end