class RemoveLabelReferenceFromCourses < ActiveRecord::Migration[5.1]
  def change
    remove_reference :courses, :label
  end
end
