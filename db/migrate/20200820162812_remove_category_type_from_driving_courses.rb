class RemoveCategoryTypeFromDrivingCourses < ActiveRecord::Migration[5.1]
  def change
    remove_column :driving_courses, :category_type
  end
end
