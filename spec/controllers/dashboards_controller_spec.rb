require 'rails_helper'

RSpec.describe DashboardsController do
  sign_in_as_role :librarian

  before do
    5.times do
      Book.create(title: Faker::Book.title, author: Faker::Book.author, genre: Faker::Book.genre, isbn: Faker::Code.isbn, total_copies: rand(1..100))
    end

    3.times do
      User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "password", role: :member)
    end

    5.times do
      Borrowing.create(
        book_id: Book.ids.sample,
        user_id: User.where(role: :member).ids.sample,
        approved_by_id: user.id,
        borrowed_at: Time.now,
        returned_at: DateTime.now + rand(1..30).days
      )
    end
  end

  describe "GET #admin_borrowings" do
    it "returns http success" do
      get :borrowings

      expect(response['total_books']).to eq(20)
      expect(response['total_borrowed']).to eq(10)
      expect(response['total_books_due_today']).to eq(2)
      expect(response['members_overdue'].length).to eq(5)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #member_borrowings" do
    it "returns http success" do
      get :member_borrowings, params: { id: User.where(role: :member).ids.sample }

      expect(response['borrowed_books'].length).to eq(2)
      expect(response['borrowed_books'].first['due_date']).to eq('2025-06-17')
      expect(response['borrowed_books'].second['overdue']).to eq('true')
      expect(response).to have_http_status(:success)
    end
  end

end
