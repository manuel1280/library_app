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
#  due_date       :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at, presence: true
  validate :book_is_available, on: :create
  validate :returned_at_cannot_be_in_the_future
  validate :returned_at_after_borrowed_at

  before_save :set_due_date

  scope :due_today, -> {  where('DATE(due_date) = ?', Date.today) }
  scope :borrowed, -> { where(returned_at: nil) }

  def self.summary_report
    OpenStruct.new(
      total_books: Book.count,
      total_borrowings: Borrowing.count,
      total_borrowed_books_today: Borrowing.where(returned_at: nil ).count,
      total_books_due_today: due_today.count,
      members_overdue: members_overdue,
    )
  end

  def self.members_overdue
    Borrowing.where(returned_at: nil).where('due_date < ?', Date.today).distinct(:user_id).map(&:user)
  end

  def overdue?
    returned_at.nil? && due_date < Date.today
  end

  private

  def set_due_date
    self.due_date = borrowed_at + 14.days
  end

  def book_is_available
    errors.add(:book, "is already borrowed") if book.borrowings.where(returned_at: nil).exists?
  end

  def returned_at_cannot_be_in_the_future
    errors.add(:returned_at, "cannot be in the future") if returned_at && returned_at > Date.today
  end

  def returned_at_after_borrowed_at
    errors.add(:returned_at, "must be after borrowed_at") if returned_at && returned_at < borrowed_at
  end
end
