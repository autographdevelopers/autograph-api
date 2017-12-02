describe EmployeeNotificationsSettingsSet do
  context 'relations' do
    it { should belong_to(:employee_driving_school) }
  end

  context 'validations' do
    it { should validate_inclusion_of(:push_notifications_enabled).in_array([true, false]) }
    it { should validate_inclusion_of(:weekly_emails_reports_enabled).in_array([true, false]) }
    it { should validate_inclusion_of(:monthly_emails_reports_enabled).in_array([true, false]) }
  end
end
