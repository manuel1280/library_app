# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  tokens                 :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer
#
class User < ActiveRecord::Base
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { librarian: 0,  member: 1, super_admin: 2 }

  has_many :borrowings

  before_save -> { skip_confirmation! }

  def summary_report
    OpenStruct.new(
      borrowed_books: borrowings.map{|b| [ b.book.id, b.due_date, b.overdue? ]},
    )
  end
end
