class AddValidTimeFramesToScheduleSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :schedule_settings, :valid_time_frames, :json, null: false,
               default: {
                 "monday" => Schedule::SLOT_START_TIMES.keys,
                 "tuesday" => Schedule::SLOT_START_TIMES.keys,
                 "wednesday" => Schedule::SLOT_START_TIMES.keys,
                 "thursday" => Schedule::SLOT_START_TIMES.keys,
                 "friday" => Schedule::SLOT_START_TIMES.keys,
                 "saturday" => Schedule::SLOT_START_TIMES.keys,
                 "sunday" => Schedule::SLOT_START_TIMES.keys
               }
  end
end
