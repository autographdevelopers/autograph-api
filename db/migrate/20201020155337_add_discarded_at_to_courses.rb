class AddDiscardedAtToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :discarded_at, :datetime
    add_index :courses, :discarded_at
  end
end
