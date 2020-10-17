class CreateCourseTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :course_types do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.references :driving_school

      t.timestamps
    end

    add_index :course_types, [:name, :driving_school_id, :status], unique: true
  end
end
