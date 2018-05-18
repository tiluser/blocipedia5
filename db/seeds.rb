# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'random_data'

1.times do
    User.create!(
        email:   "tiluser0@gmail.com",
        password: "helloworld",
        role: "admin"
    )
    User.create!(
        email:   "tiluser@yahoo.com",
        password: "abc123",
        role: "premium"
    )
end

10.times do
     User.create!(
        email:   "#{Faker::Internet.user_name}@jmoshowcase.com",
        password: "wordpass",
        role: "standard"
    )
end

50.times do
    Wiki.create!(
        title:    Faker::Lorem.sentence,
        body:   Faker::Lorem.sentences,
        private: false,
        user_id: 1
    )
end

