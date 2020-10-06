class RenameDrivingCourse < ActiveRecord::Migration[5.1]
  def change
    rename_table :course_participations, :course_participations
    remove_reference :course_participations, :labelable_label
  end
end
