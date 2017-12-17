class EmployeeNotificationsSettingsSet < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :employee_driving_school

  # == Validations ============================================================
  validates :push_notifications_enabled, :weekly_emails_reports_enabled, :monthly_emails_reports_enabled,
            inclusion: { in: [true, false] }
end
