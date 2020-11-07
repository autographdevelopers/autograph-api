class CreateCourseTypeReferenceToCourses < ActiveRecord::Migration[5.1]
  def up
    add_reference :courses, :course_type, null: false, foreign_key: true
  end

  def down
    remove_reference :courses, :course_type, index: true, foreign_key: true
  end
end
