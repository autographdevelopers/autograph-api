class CreateSlots < ActiveRecord::Migration[5.1]
  def change
    create_table :slots do |t|
      t.datetime :start_time, null: false
      t.references :employee_driving_school, foreign_key: true, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
