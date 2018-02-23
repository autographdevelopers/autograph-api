class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.integer :repetition_period_in_weeks, null: false, default: 12
      t.json :slots_template, null: false, default: {}
      t.references :employee_driving_school, foreign_key: true, null: false

      t.timestamps
    end
  end
end
