require 'rails_helper'

RSpec.describe BooksController do
  sign_in_as_role :librarian

  before do
    5.times do
      Book.create(title: Faker::Book.title, author: Faker::Book.author, genre: Faker::Book.genre, isbn: Faker::Code.isbn, total_copies: rand(1..100))
    end
  end

  def success_response_expected
    expect(response).to have_http_status(:success)
  end

  context 'when user is signed in' do
    describe "GET #index" do
      it "returns http success" do
        get :index

        success_response_expected
      end
    end
    describe "post #create" do
      let(:new_book) { { title: Faker::Book.title, author: Faker::Book.author, genre: Faker::Book.genre, isbn: Faker::Code.isbn, total_copies: rand(1..100) } }
      it "returns http success" do
        post :create, params: { book: new_book }, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    describe "get #show" do
      it "returns http success" do
        book = Book.first
        get :show, params: { id: book.id }, format: :json
        body_response = JSON.parse(response.body)
        body_response['data']['id'] = book.id
        success_response_expected
      end
    end

    describe  "post #destroy" do
      it "returns http success" do
        book = Book.first
        post :destroy, params: { id: book.id }, format: :json

        expect(Book.find_by(id: book.id)).to eq(nil)
        expect(response).to have_http_status(:success)
      end
    end

    describe  "post #update" do
      it "returns http success" do
        book = Book.first
        new_title = Faker::Book.title
        post :update, params: { id: book.id, book: { title: new_title } }, format: :json

        expect(Book.find(book.id).title).to eq(new_title)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
