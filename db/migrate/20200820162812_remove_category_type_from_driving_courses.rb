class RemoveCategoryTypeFromDrivingCourses < ActiveRecord::Migration[5.1]
  def change
    remove_column :course_participations, :category_type
  end
end
