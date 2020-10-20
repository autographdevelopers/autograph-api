class AddDiscardedAtToDrivingSchools < ActiveRecord::Migration[5.1]
  def change
    add_column :driving_schools, :discarded_at, :datetime
    add_index :driving_schools, :discarded_at
  end
end
