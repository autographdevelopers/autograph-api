class AddDefaultAvailableHoursToCourseProgress < ActiveRecord::Migration[5.1]
  def change
    change_column :driving_courses, :available_hours, :decimal, default: 10.00, null: false
  end
end
