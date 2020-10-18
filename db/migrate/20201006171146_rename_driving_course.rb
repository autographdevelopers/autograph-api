class RenameDrivingCourse < ActiveRecord::Migration[5.1]
  def change
    rename_table :driving_courses, :course_participation_details
    remove_reference :course_participation_details, :labelable_label
  end
end
