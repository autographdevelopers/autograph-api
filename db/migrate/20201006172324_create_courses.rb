class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :course_participations do |t|
      t.string :name, null: false
      t.text :description
      t.references :label
      t.references :driving_school
      t.datetime :start_time
      t.datetime :end_time
      t.integer :course_participations_limit
      t.integer :course_participations_count, default: 0, null: false
    end
  end
end
