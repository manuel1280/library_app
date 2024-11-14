# == Schema Information
#
# Table name: books
#
#  id           :integer          not null, primary key
#  title        :string
#  author       :string
#  genre        :string
#  isbn         :string
#  total_copies :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Book < ApplicationRecord
	validates :title, :author, :genre, :isbn, :total_copies, presence: true
	validates :isbn, uniqueness: true
	validates :total_copies, numericality: { greater_than: 0 }

	has_many :borrowings

	scope :available, -> { where.not(id: Borrowing.borrowed.pluck(:book_id)) }
end
