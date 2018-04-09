class AddMaximumSlotsCountPerDrivingLessonToScheduleSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :schedule_settings, :maximum_slots_count_per_driving_lesson, :integer, default: 8
  end
end
