class RemoveUsedHoursAndBookedHoursFromDrivingCourse < ActiveRecord::Migration[5.1]
  def change
    remove_column :driving_courses, :used_hours, :integer, default: 0, null: false
    remove_column :driving_courses, :booked_hours, :integer, default: 0, null: false
  end
end
