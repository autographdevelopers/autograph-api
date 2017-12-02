describe ScheduleSetting do
  context 'relations' do
    it { should belong_to(:driving_school) }
  end

  context 'validations' do
    it { should validate_presence_of(:holidays_enrollment_enabled) }
    it { should validate_presence_of(:last_minute_booking_enabled) }
  end
end
