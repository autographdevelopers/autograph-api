class ChangeDrivingLessonRelations < ActiveRecord::Migration[5.1]
  def change
    remove_reference :driving_lessons, :student_driving_school, foreign_key: true, null: false
    remove_reference :driving_lessons, :employee_driving_school, foreign_key: true, null: false

    add_reference :driving_lessons, :student, foreign_key: { to_table: :users }, null: false
    add_reference :driving_lessons, :employee, foreign_key: { to_table: :users }, null: false
    add_reference :driving_lessons, :driving_school, foreign_key: true, null: false
  end
end
