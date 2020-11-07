class AddUniIndexToCourseParrcDetc < ActiveRecord::Migration[5.1]
  def change
    add_index :course_participation_details, [:student_driving_school_id, :course_id, :status, :discarded_at], unique: true, name: 'index_course_part_dets_on_stud_school_id_and_course_id_status'
  end
end
