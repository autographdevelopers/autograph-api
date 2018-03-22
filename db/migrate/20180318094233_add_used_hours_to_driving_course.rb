class AddUsedHoursToDrivingCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :driving_courses, :used_hours, :integer, default: 0, null: false
  end
end
