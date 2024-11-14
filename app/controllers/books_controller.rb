class BooksController < ApplicationController
  before_action :authenticate_user!

  def create
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
    @books = Book.all

    render json: @books, status: :ok
  end
end
