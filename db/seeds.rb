# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create a main sample user.
User.create!(name:  "Example User", email: "cenas@etal.pt", phone: 123456789, password: "testepw", password_confirmation: "testepw", admin: true)

# Generate a bunch of additional users.
99.times do |n|
    name = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    phone = 123456789
    password = "password"
    User.create!(name: name, email: email, phone: phone, password: password, password_confirmation: password)
end

# Generate microposts for a subset of users. users = User.order(:created_at).take(6) 50.times do
users = User.order(:created_at).take(6)
50.times do
    content = Faker::Lorem.sentence(word_count: 5)
    users.each { |user| user.microposts.create!(content: content) }
end

# Create following relationships.
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

Address.create!(user_id: user[:id],address: "morada teste", city: "lisboa", zip_code: "123123", country: "Portugal")