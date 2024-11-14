class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def admin_borrowings
    @borrowings = Borrowing.summary_report
    render json: @borrowings
  end

  def member_borrowings
    @borrowings = User.find(params[:id]).member_borrowings_report
    render json: @borrowings

    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :not_found
  end
end
