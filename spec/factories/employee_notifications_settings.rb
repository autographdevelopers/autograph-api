FactoryBot.define do
  factory :employee_notifications_settings do
    push_notifications_enabled { false }
    weekly_emails_reports_enabled { false }
    monthly_emails_reports_enabled { false }
    employee_driving_school
  end
end
