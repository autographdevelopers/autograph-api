class AddDefaultAvailableHoursToCourseProgress < ActiveRecord::Migration[5.1]
  def change
    change_column :course_participations, :available_hours, :decimal, default: 10.00, null: false
  end
end
