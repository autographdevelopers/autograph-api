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

    context '#current_template_format' do
      subject { build(:schedule, current_template: template) }

      context 'when current_template does NOT contain all weekdays' do
        let(:template) do
          { monday: [], tuesday: [], wednesday: [], thursday: [12], friday: [12], saturday: [] }
        end

        it { is_expected.not_to be_valid }
      end

      context 'when current_template contains INVALID weekday' do
        let(:template) do
          { monday: [], tuesday: [], wednesday: [], thursday: [12], friday: [12], saturday: [], sunday: [], invalid: [] }
        end

        it { is_expected.not_to be_valid }
      end

      context 'when current_template contains INVALID slot start times ids' do
        let(:template) do
          { monday: [-1], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: [] }
        end

        it { is_expected.not_to be_valid }
      end

      context 'when current_template contains DUPLICATED slot start times ids' do
        let(:template) do
          { monday: [], tuesday: [], wednesday: [], thursday: [12, 12], friday: [12], saturday: [], sunday: [], invalid: [] }
        end

        it { is_expected.not_to be_valid }
      end

      context 'when current_template contains VALID weekdays with VALID slot start times ids' do
        let(:template) do
          { monday: [0, 47], tuesday: [1, 2], wednesday: [3,5], thursday: [7,8], friday: [], saturday: [], sunday: [] }
        end

        it { is_expected.to be_valid }
      end
    end

    context '#new_template_format' do
      subject { build(:schedule, new_template: template) }

      context 'when new_template_format does NOT contain all weekdays' do
        let(:template) do
          { monday: [], tuesday: [], wednesday: [], thursday: [12], friday: [12], saturday: [] }
        end

        it { is_expected.not_to be_valid }
      end

      context 'when new_template_format contains INVALID weekday' do
        let(:template) do
          { monday: [], tuesday: [], wednesday: [], thursday: [12], friday: [12], saturday: [], sunday: [], invalid: [] }
        end

        it { is_expected.not_to be_valid }
      end

      context 'when new_template_format contains INVALID slot start times ids' do
        let(:template) do
          { monday: [-1], tuesday: [], wednesday: [], thursday: [], friday: [], saturday: [] }
        end

        it { is_expected.not_to be_valid }
      end

      context 'when new_template_format contains DUPLICATED slot start times ids' do
        let(:template) do
          { monday: [], tuesday: [], wednesday: [], thursday: [12, 12], friday: [12], saturday: [], sunday: [], invalid: [] }
        end

        it { is_expected.not_to be_valid }
      end

      context 'when new_template_format contains VALID weekdays with VALID slot start times ids' do
        let(:template) do
          { monday: [0, 47], tuesday: [1, 2], wednesday: [3,5], thursday: [7,8], friday: [], saturday: [], sunday: [] }
        end

        it { is_expected.to be_valid }
      end
    end

    context '#new_template_binding_from_to_be_in_the_future' do
      subject { build(:schedule, new_template_binding_from: new_template_binding_from) }

      context 'when new_template_binding_from is set to 2 days ago' do
        let(:new_template_binding_from) { 2.days.ago }

        it { is_expected.not_to be_valid }
      end

      context 'when new_template_binding_from is set to today' do
        let(:new_template_binding_from) { Date.today }

        it { is_expected.not_to be_valid }
      end

      context 'when new_template_binding_from is set to tomorrow' do
        let(:new_template_binding_from) { Date.tomorrow }

        it { is_expected.to be_valid }
      end

      context 'when new_template_binding_from is set to 3 days from now' do
        let(:new_template_binding_from) { 3.days.from_now }

        it { is_expected.to be_valid }
      end
    end
  end
end
