require 'rails_helper'

RSpec.describe BorrowingsController do
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

  context 'when user is signed in' do
    let!(:borrowing) { Borrowing.first }

    describe "GET #index" do
      it "returns http success" do
        get :index

        body_response = JSON.parse(response.body)
        expect(body_response.length).to eq(5)
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: borrowing.id }, format: :json

        body_response = JSON.parse(response.body)
        expect(body_response['id']).to eq(borrowing.id)
        expect(response).to have_http_status(:success)
      end
    end

    describe  "post #destroy" do
      it "returns http success" do
        delete :destroy, params: { id: borrowing.id }, format: :json
        expect(Borrowing.find_by(id: borrowing.id)).to be_nil
        expect(response).to have_http_status(:success)
      end
    end

    describe  "post #update" do
      it "returns http success" do
        put :update, params: { id: borrowing.id, borrowing: { returned_at: '2025-01-01' } }, format: :json
        expect(Borrowing.find_by(id: borrowing.id).returned_at).to eq('2025-01-01')
        expect(response).to have_http_status(:success)
      end
    end
  end
end
