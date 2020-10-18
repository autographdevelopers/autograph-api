class AddCourseReferenceToCourseParticipations < ActiveRecord::Migration[5.1]
  def change
    add_reference :course_participation_details, :course, null: false, foreign_key: true
  end
end
