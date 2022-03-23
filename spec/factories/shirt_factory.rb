FactoryBot.define do
  factory :shirt do
    # code {Faker::Code.ean}
    color { Faker::Color.color_name }
    size { "M" }
    print { Faker::Superhero.name }
    quantity { Faker::Number.decimal_part(digits: 2) }
    aditional_description { Faker::Lorem.sentence(word_count: 20) }
    owner { association :user }
    store
  end
end