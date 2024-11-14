FactoryBot.define do
  factory :borrowing do
    borrowed_at { Date.yesterday }
    approved_by_id { create(:user, role: :librarian) }
    association :user
    association :book
  end
end

