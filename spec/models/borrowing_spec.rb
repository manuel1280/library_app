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
require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
