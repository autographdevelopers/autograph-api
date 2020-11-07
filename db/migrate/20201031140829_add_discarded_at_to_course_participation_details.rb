class AddDiscardedAtToCourseParticipationDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :course_participation_details, :discarded_at, :datetime
    add_index :course_participation_details, :discarded_at
  end
end
