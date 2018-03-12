class RenameScheduleSettingsSet < ActiveRecord::Migration[5.1]
  def change
    rename_table :schedule_settings_sets, :schedule_settings
  end
end
