# == Schema Information
#
# Table name: borrowings
#
#  id             :integer          not null, primary key
#  user_id        :integer          not null
#  book_id        :integer          not null
#  borrowed_at    :datetime
#  returned_at    :datetime
#  approved_by_id :integer
#  due_to         :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  before_save :set_due_date

  def self.summary_report
    OpenStruct.new(
      total_borrowings: Borrowing.count,
      total_borrowed_books: Borrowing.where(returned_at: nil ).count,
      total_books_due_today: Borrowing.where(due_to: Date.today).count,
      member_overdue: members_overdue,
    )
  end

  def self.members_overdue
    Borrowing.where(returned_at: nil).where('due_to < ?', Date.today).distinct(:user_id).map(&:user)
  end

  def overdue?
    returned_at.nil? && due_to < Date.today
  end

  private

  def set_due_date
    self.due_to = borrowed_at + 14.days
  end
end
