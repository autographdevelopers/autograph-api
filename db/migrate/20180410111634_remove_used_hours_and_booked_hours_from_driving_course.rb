class RemoveUsedHoursAndBookedHoursFromDrivingCourse < ActiveRecord::Migration[5.1]
  def change
    remove_column :course_participations, :used_hours, :integer, default: 0, null: false
    remove_column :course_participations, :booked_hours, :integer, default: 0, null: false
  end
end
