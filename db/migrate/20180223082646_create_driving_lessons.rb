class CreateDrivingLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :driving_lessons do |t|
      t.datetime :start_time, null: false
      t.references :student_driving_school, foreign_key: true, null: false
      t.references :employee_driving_school, foreign_key: true, null: false

      t.timestamps
    end
  end
end
