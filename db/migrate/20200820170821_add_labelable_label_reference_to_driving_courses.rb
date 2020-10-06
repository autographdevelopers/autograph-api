class AddLabelableLabelReferenceToDrivingCourses < ActiveRecord::Migration[5.1]
  def change
    add_reference :course_participations, :labelable_label, foreign_key: true, null: false
  end
end
