class AddCourseParticipationDetailsReferenceToDrivingLessons < ActiveRecord::Migration[5.1]
  def change
    remove_reference :driving_lessons, :course
    add_reference :driving_lessons, :course_participation_detail, null: false, foreign_key: true
  end
end
