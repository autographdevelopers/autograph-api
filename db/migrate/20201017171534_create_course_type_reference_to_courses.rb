class CreateCourseTypeReferenceToCourses < ActiveRecord::Migration[5.1]
  def change
    add_reference :courses, :course_type, null: false, foreign_key: true
  end
end
