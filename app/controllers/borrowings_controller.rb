class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_borrowing, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def create
    @borrowing = Borrowing.new(borrowing_params)
    if @borrowing.save
      render json: @borrowing, status: :created
    else
      render json: @borrowing.errors, status: :unprocessable_entity
    end
  end

  def update
    if @borrowing.update(borrowing_params)
      render json: @borrowing
    else
      render json: @borrowing.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @borrowing.destroy
      render json: { message: "Borrowing deleted successfully" }, status: :ok
    else
      render json: @borrowing.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @borrowing, status: :ok
  end

  def index
    @borrowings = Borrowing.all
    render json: @borrowings, status: :ok
  end

  private

  def borrowing_params
    params.require(:borrowing).permit(:user_id, :book_id, :borrowed_at, :returned_at, :approved_by_id)
  end

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end
end
