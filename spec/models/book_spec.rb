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
require 'rails_helper'

RSpec.describe Book, type: :model do
  # spec/models/book_spec.rb
  require 'rails_helper'

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:genre) }
    it { should validate_presence_of(:isbn) }
    it { should validate_presence_of(:total_copies) }
    it { should validate_uniqueness_of(:isbn) }
    it { should validate_numericality_of(:total_copies).is_greater_than(0) }
  end

  describe 'associations' do
    it { should have_many(:borrowings) }
  end

  describe 'scopes' do
    describe '.available' do
      let!(:member) { create(:user, role: :member) }
      let!(:borrowed_book) { create(:book)}
      let!(:available_book) { create(:book) }


      let!(:borrowing_returned) { create(:borrowing, user: member, book: available_book, returned_at: Date.today) }
      let!(:borrowing_not_returned) { create(:borrowing, user: member, book: borrowed_book, returned_at: nil) }

      it 'returns books that are not currently borrowed' do
        expect(Book.available).to include(available_book)
        expect(Book.available).not_to include(borrowed_book)
      end
    end
  end
end
