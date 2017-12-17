class CreateScheduleSettingsSet < ActiveRecord::Migration[5.1]
  def change
    create_table :schedule_settings_sets do |t|
      t.boolean :holidays_enrollment_enabled, null: false, default: false
      t.boolean :last_minute_booking_enabled, null: false, default: false
      t.references :driving_school,           null: false

      t.timestamps
    end
  end
end
