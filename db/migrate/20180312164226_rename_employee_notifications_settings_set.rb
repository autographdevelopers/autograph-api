class RenameEmployeeNotificationsSettingsSet < ActiveRecord::Migration[5.1]
  def change
    rename_table :employee_notifications_settings_sets, :employee_notifications_settings
  end
end
