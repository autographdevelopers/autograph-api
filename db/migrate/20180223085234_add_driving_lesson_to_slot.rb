class AddDrivingLessonToSlot < ActiveRecord::Migration[5.1]
  def change
    add_reference :slots, :driving_lesson, foreign_key: true
  end
end
