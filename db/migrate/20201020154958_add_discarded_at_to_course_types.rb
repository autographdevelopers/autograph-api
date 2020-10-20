class AddDiscardedAtToCourseTypes < ActiveRecord::Migration[5.1]
  def change
    add_column :course_types, :discarded_at, :datetime
    add_index :course_types, :discarded_at
  end
end
