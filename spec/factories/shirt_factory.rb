FactoryBot.define do
  factory :shirt do
    code {Faker::Code.ean}
    color { Faker::Color.color_name }
    size { "M" }
    print { Faker::Superhero.name }
    quantity { Faker::Number.decimal_part(digits: 2) }
    additional_description { Faker::Lorem.sentence(word_count: 20) }
    store
  end
end