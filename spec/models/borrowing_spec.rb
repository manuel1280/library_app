# == Schema Information
#
# Table name: borrowings
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  book_id     :integer          not null
#  borrored_at :datetime
#  returned_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
