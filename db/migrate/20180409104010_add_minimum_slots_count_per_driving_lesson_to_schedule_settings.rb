class AddMinimumSlotsCountPerDrivingLessonToScheduleSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :schedule_settings, :minimum_slots_count_per_driving_lesson, :integer, default: 1
  end
end
