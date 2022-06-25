# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(
  name: 'Admin',
  lastname: 'account',
  country: 'VE',
  email: 'admin@gmail.com',
  password: "123456789",
  password_confirmation: "123456789"
)

puts (user.nil? ? user.erros : 'Admin user created')

store = Store.create(
  name: 'Mercado',
  location: 'San Martin',
  owner: user
)

shirts = [
  {
    color: 'red',
    size: 'M',
    print: 'Punisher',
    quantity: 20,

  },
  {
    color: 'red',
    size: 'M',
    print: 'Punisher',
    quantity: 20,

  },
  {
    color: 'red',
    size: 'M',
    print: 'Punisher',
    quantity: 20,

  },
  {
    color: 'red',
    size: 'M',
    print: 'Punisher',
    quantity: 20,

  },
]

shirts.each do |shirt|
  sh = Shirt.create!(
    color: shirt[:color],
    size: shirt[:size],
    print: shirt[:print],
    quantity: shirt[:quantity],
    owner: user,
    store: store
  )
end

