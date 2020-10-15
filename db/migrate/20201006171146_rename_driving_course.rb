class RenameDrivingCourse < ActiveRecord::Migration[5.1]
  def change
    rename_table :driving_courses, :course_participations
    remove_reference :course_participations, :labelable_label
  end
end
