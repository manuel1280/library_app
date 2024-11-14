# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts " ********* creating users **********"
User.create(name: "John Doe", email: "kK8r6@example.com", password: "password", role: :super_admin)
User.create(name: "Jane Doe", email: "4Yt4d@example.com", password: "password", role: :librarian)

10.times do
	User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "password", role: :member)
end
puts " ********* users created **********"

puts " ********* creating books **********"
20.times do
	Book.create(title: Faker::Book.title, author: Faker::Book.author, genre: Faker::Book.genre, isbn: Faker::Code.isbn, total_copies: rand(1..100))
end
puts " ********* books created **********"

puts " ********* creating borrowings **********"
20.times do
	member_ids = User.where(role: :member).ids
	book_ids = Book.ids
	librarian_id = User.find_by(role: :librarian).id
	Borrowing.create(user_id: member_ids.sample, book_id: book_ids.sample, approved_by_id: librarian_id)
end
puts " ********* borrowings created **********"