class AddUniqIndexToCoursesAndCoursesTypes < ActiveRecord::Migration[5.1]
  def change
    add_index :courses, [:name, :driving_school_id, :status, :discarded_at], unique: true, name: 'courses_name_school_id_status_discarded_at_uniq'
    add_index :course_types, [:name, :driving_school_id, :status], unique: true, name: 'course_typ_name_school_id_status_discarded_at_uniq'
  end
end
