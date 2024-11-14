require 'rails_helper'

RSpec.describe DashboardsController do
  sign_in_as_role :librarian

  def valid_returned_date(borrowed_at)
    ((borrowed_at.to_date + 1.day)..Date.today).to_a.sample
  end

  before do
    30.times do
      Book.create(title: Faker::Book.title, author: Faker::Book.author, genre: Faker::Book.genre, isbn: Faker::Code.isbn, total_copies: rand(1..100))
    end

    5.times do
      User.create(name: Faker::Name.name, email: Faker::Internet.email, password: "password", role: :member)
    end

    10.times do
      borrowed_at = rand(2..30).days.ago
      Borrowing.create!(
        book_id: Book.available.ids.sample,
        user_id: User.where(role: :member).ids.sample,
        approved_by_id: user.id,
        borrowed_at: borrowed_at,
        returned_at: valid_returned_date(borrowed_at)
      )
    end

    10.times do
      Borrowing.create!(
        book_id: Book.available.ids.sample,
        user_id: User.where(role: :member).ids.sample,
        approved_by_id: user.id,
        borrowed_at: rand(1..10).days.ago,
        returned_at: nil
      )
    end

    2.times do
      Borrowing.create!(
        book_id: Book.available.ids.sample,
        user_id: User.where(role: :member).ids.sample,
        approved_by_id: user.id,
        borrowed_at: 14.days.ago,
        returned_at: nil
      )
    end

    3.times do
      Borrowing.create!(
        book_id: Book.available.ids.sample,
        user_id: User.where(role: :member).ids.sample,
        approved_by_id: user.id,
        borrowed_at: 20.days.ago,
        returned_at: nil
      )
    end
  end

  describe "GET #admin_borrowings" do
    it "returns http success" do
      get :admin_borrowings

      body_response = JSON.parse(response.body)['table']

      expect(body_response['total_books']).to eq(30)
      expect(body_response['total_borrowings']).to eq(25)
      expect(body_response['total_borrowed_books_today']).to eq(15)
      expect(body_response['total_books_due_today']).to eq(2)
      expect(body_response['members_overdue'].length).to eq(3)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #member_borrowings" do
    let!(:member) { create(:user) }
    let!(:borrowing) { create(:borrowing, book_id: Book.available.ids.sample, user: member, borrowed_at: 3.days.ago, returned_at: Date.yesterday) }
    let!(:overdue_borrowing) { create(:borrowing, book_id: Book.available.ids.sample, user: member, borrowed_at: 20.days.ago, returned_at: nil) }

    it "returns http success" do
      get :member_borrowings, params: { id: member.id }

      body_response = JSON.parse(response.body)['table']

      expect(body_response['borrowed_books'].length).to eq(2)
      expect(body_response['borrowed_books'].first['due_date'].to_date).to eq((3.days.ago + 14.days).to_date)
      expect(body_response['borrowed_books'].second['overdue']).to eq(true)
      expect(response).to have_http_status(:success)
    end
  end

end
