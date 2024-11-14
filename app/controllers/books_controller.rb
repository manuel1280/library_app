class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @book.destroy
      render json: { message: "Book deleted successfully" }, status: :ok
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def show
    @book
  end

  def index
    @books = Book.all
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies)
  end

  def render_not_found
    render json: { error: "Book not found" }, status: :not_found
  end
end
