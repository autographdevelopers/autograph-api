describe ScheduleSettings do
  context 'relations' do
    it { should belong_to(:driving_school) }
  end

  context 'validations' do
    it { should validate_presence_of(:valid_time_frames) }
    it { should validate_presence_of(:minimum_slots_count_per_driving_lesson) }
    it { should validate_presence_of(:maximum_slots_count_per_driving_lesson) }
    it { should validate_presence_of(:booking_advance_period_in_weeks) }
    it { should validate_inclusion_of(:holidays_enrollment_enabled).in_array([true, false]) }
    it { should validate_inclusion_of(:last_minute_booking_enabled).in_array([true, false]) }
    it { should validate_inclusion_of(:can_student_book_driving_lesson).in_array([true, false]) }
    it {
      should validate_inclusion_of(:booking_advance_period_in_weeks).in_range(
        ScheduleSettings::MIN_SCHEDULE_REPETITION_PERIOD..ScheduleSettings::MAX_SCHEDULE_REPETITION_PERIOD
      )
    }
  end

  context 'callbacks' do
    context '#update_schedules' do
      let(:driving_school) do
        create(:driving_school, status: :active)
      end

      let!(:schedule_settings) do
        create(:schedule_settings,
               booking_advance_period_in_weeks: 1,
               holidays_enrollment_enabled: false,
               driving_school: driving_school)
      end

      let!(:employee_driving_school_1) do
        create(:employee_driving_school,
               driving_school: driving_school,
               status: :active,
               is_driving: true)
      end

      let!(:employee_driving_school_2) do
        create(:employee_driving_school,
               status: :active,
               driving_school: driving_school,
               is_driving: false)
      end

      context 'when updating booking_advance_period_in_weeks' do
        after do
          schedule_settings.update(
            booking_advance_period_in_weeks: 4
          )
        end

        it 'triggers Slots::RescheduleAllService for each employee in driving school' do
          instance = double
          expect(Slots::RescheduleAllService).to receive(:new).with(employee_driving_school_1.schedule)
                                                              .and_return(instance)
          expect(instance).to receive(:call)
        end
      end

      context 'when is NOT updating booking_advance_period_in_weeks' do
        after do
          schedule_settings.update(
            holidays_enrollment_enabled: true
          )
        end

        it 'does NOT triggers Slots::RescheduleAllService' do
          expect(Slots::RescheduleAllService).not_to receive(:new)
        end
      end
    end
  end
end
