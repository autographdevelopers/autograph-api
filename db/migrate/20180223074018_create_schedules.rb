class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.integer :repetition_period_in_weeks, null: false, default: 0
      t.json :current_template, null: false, default: { monday: [], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: [], sunday: [] }
      t.json :new_template, null: false, default: { monday: [], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: [], sunday: [] }
      t.date :new_template_binding_from
      t.references :employee_driving_school, foreign_key: true, null: false

      t.timestamps
    end
  end
end
