class CreateStudentDrivingSchools < ActiveRecord::Migration[5.1]
  def change
    create_table :student_driving_schools do |t|
      t.references :student, foreign_key: { to_table: :users }
      t.references :driving_school, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
