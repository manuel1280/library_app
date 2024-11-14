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
require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  require 'rails_helper'

  describe 'validations' do

    describe 'custom validations' do
      let!(:book) { create(:book) }
      let!(:user) { create(:user) }
      let(:borrowing) { build(:borrowing, book: book, user: user, borrowed_at: Date.today) }

      context 'when book is already borrowed' do
        before { create(:borrowing, book: book, returned_at: nil) }

        it 'is not valid' do

          expect(borrowing).not_to be_valid
          expect(borrowing.errors[:book]).to include("is already borrowed")
        end
      end

      context 'when returned_at is in the future' do
        before { borrowing.returned_at = Date.today + 1.day }

        it 'is not valid' do
          expect(borrowing).not_to be_valid
          expect(borrowing.errors[:returned_at]).to include("cannot be in the future")
        end
      end

      context 'when returned_at is before borrowed_at' do
        before do
          borrowing.borrowed_at = Date.today
          borrowing.returned_at = Date.yesterday
        end

        it 'is not valid' do
          expect(borrowing).not_to be_valid
          expect(borrowing.errors[:returned_at]).to include("must be after borrowed_at")
        end
      end
    end
  end

  describe 'scopes' do
    describe '.due_today' do
      let!(:due_today_borrowing) { create(:borrowing, borrowed_at: Date.today - 14.days) }
      let!(:not_due_today_borrowing) { create(:borrowing, borrowed_at: Date.today - 15.days) }

      it 'includes borrowings due today' do
        expect(Borrowing.due_today).to include(due_today_borrowing)
      end

      it 'excludes borrowings not due today' do
        expect(Borrowing.due_today).not_to include(not_due_today_borrowing)
      end
    end

    describe '.borrowed' do
      let!(:borrowed_borrowing) { create(:borrowing, returned_at: nil) }
      let!(:returned_borrowing) { create(:borrowing, returned_at: Date.yesterday) }

      it 'includes borrowings that have not been returned' do
        expect(Borrowing.borrowed).to include(borrowed_borrowing)
      end

      it 'excludes borrowings that have been returned' do
        expect(Borrowing.borrowed).not_to include(returned_borrowing)
      end
    end
  end

  describe 'class methods' do
    describe '.summary_report' do
      it 'returns a summary report with the expected fields' do
        report = Borrowing.summary_report
        expect(report).to respond_to(:total_books)
        expect(report).to respond_to(:total_borrowings)
        expect(report).to respond_to(:total_borrowed_books_today)
        expect(report).to respond_to(:total_books_due_today)
        expect(report).to respond_to(:members_overdue)
      end
    end

    describe '.members_overdue' do
      let(:user) { create(:user) }
      let!(:overdue_borrowing) { create(:borrowing, user: user, borrowed_at: Date.yesterday, returned_at: nil) }
      let!(:not_overdue_borrowing) { create(:borrowing, user: user, borrowed_at: 20.days.ago, returned_at: nil) }

      it 'includes users with overdue borrowings' do
        expect(Borrowing.members_overdue).to include(user)
      end

      it 'excludes users without overdue borrowings' do
        expect(Borrowing.members_overdue).not_to include(create(:user))
      end
    end
  end

  describe '#overdue?' do
    let(:borrowing) { build(:borrowing, due_date: Date.yesterday, returned_at: nil) }

    it 'returns true if the borrowing is overdue' do
      expect(borrowing.overdue?).to be true
    end

    it 'returns false if the borrowing is not overdue' do
      borrowing.due_date = Date.tomorrow
      expect(borrowing.overdue?).to be false
    end
  end

  describe 'callbacks' do
    describe 'before_save :set_due_date' do
      let(:borrowing) { build(:borrowing, borrowed_at: Date.today) }

      it 'sets the due date 14 days after borrowed_at' do
        borrowing.save
        expect(borrowing.due_date).to eq(Date.today + 14.days)
      end
    end
  end

end
