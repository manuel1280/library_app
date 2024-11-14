# == Schema Information
#
# Table name: books
#
#  id           :integer          not null, primary key
#  title        :string
#  author       :string
#  genre        :integer
#  isbn         :string
#  total_copies :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Book < ApplicationRecord
end
