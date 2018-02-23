describe Schedule do
  context 'relations' do
    it { should belong_to(:employee_driving_school) }
  end

  context 'validations' do
    it { should validate_presence_of(:current_template) }
    it { should validate_presence_of(:new_template) }
    it { should validate_presence_of(:repetition_period_in_weeks) }
    it { should validate_presence_of(:new_template_binding_from) }
    it { should validate_inclusion_of(:repetition_period_in_weeks).in_range(
      Schedule::MIN_SCHEDULE_REPETITION_PERIOD..Schedule::MAX_SCHEDULE_REPETITION_PERIOD
    ) }

    context '#slots_template_format' do

    end
  end
end
