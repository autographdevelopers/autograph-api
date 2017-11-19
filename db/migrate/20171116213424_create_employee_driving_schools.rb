class CreateEmployeeDrivingSchools < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_driving_schools do |t|
      t.references :employee, foreign_key: { to_table: :users }, null: false
      t.references :driving_school, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
