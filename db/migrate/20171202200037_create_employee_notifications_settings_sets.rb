class CreateEmployeeNotificationsSettingsSets < ActiveRecord::Migration[5.1]
  def change
    create_table :employee_notifications_settings_sets do |t|
      t.boolean :push_notifications_enabled,     null: false, default: false
      t.boolean :weekly_emails_reports_enabled,  null: false, default: false
      t.boolean :monthly_emails_reports_enabled, null: false, default: false
      t.references :employee_driving_school,
                   index: { name: 'index_employee_notification_settings_on_employee_driving_school' },
                   null: false

      t.timestamps
    end
  end
end
