class CreateDrivingCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :course_participations do |t|
      t.references :student_driving_school, foreign_key: true
      t.integer :available_hours, default: 0, null: false
      t.integer :category_type, default: 0, null: false

      t.timestamps
    end
  end
end
