describe ScheduleSettings do
  context 'relations' do
    it { should belong_to(:driving_school) }
  end

  context 'validations' do
    it { should validate_inclusion_of(:holidays_enrollment_enabled).in_array([true, false]) }
    it { should validate_inclusion_of(:last_minute_booking_enabled).in_array([true, false]) }
  end
end
