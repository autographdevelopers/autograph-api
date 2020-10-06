class AddDrivingCourseReferenceToDrivingLessons < ActiveRecord::Migration[5.1]
  def change
    add_reference :driving_lessons, :driving_course, foreign_key: true, null: false
  end
end
