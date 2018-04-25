class ChangeAvailableHoursType < ActiveRecord::Migration[5.1]
  def change
    change_column :driving_courses, :available_hours, :decimal, default: 0.0, null: false, precision: 5, scale: 1
  end
end
