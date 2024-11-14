class CreateBorrowings < ActiveRecord::Migration[7.1]
  def change
    create_table :borrowings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.datetime :borrowed_at
      t.datetime :returned_at
      t.integer :approved_by_id
      t.datetime :due_date

      t.timestamps
    end
  end
end
