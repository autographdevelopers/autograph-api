describe Schedule do
  context 'relations' do
    it { should belong_to(:employee_driving_school) }
  end

  context 'validations' do
    it { should validate_presence_of(:slots_template) }
    it { should validate_presence_of(:repetition_period_in_weeks) }
    it { should validate_inclusion_of(:repetition_period_in_weeks).in_range(
      Schedule::MIN_SCHEDULE_REPETITION_PERIOD..Schedule::MAX_SCHEDULE_REPETITION_PERIOD
    ) }
  end
end
