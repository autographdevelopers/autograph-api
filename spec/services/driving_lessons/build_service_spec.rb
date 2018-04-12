describe DrivingLessons::BuildService do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let(:driving_school) do
    create(:driving_school, status: :active)
  end

  let!(:schedule_settings) do
    create(:schedule_settings,
           driving_school: driving_school)
  end

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end

  let(:slots) { Slot.all }

  subject do
    DrivingLessons::BuildService.new(
      employee,
      employee_driving_school,
      student,
      driving_school,
      slots
    ).call
  end

  context '#validate_slots_to_be_consecutive' do
    context 'when slots are NOT consecutive' do
      let!(:slot_1) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 11, 0, 0))
      end

      let!(:slot_2) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 11, 30, 0))
      end

      let!(:slot_3) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
      end

      it 'raises BadRequest error with proper message' do
        expect { subject }.to raise_error(
          ActionController::BadRequest, 'Slots must be half an hour apart'
        )
      end
    end

    context 'when slots are NOT consecutive' do
      let!(:slot_1) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 23, 30, 0))
      end

      let!(:slot_2) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 4, 0, 0, 0))
      end

      let!(:slot_3) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 4, 0, 30, 0))
      end

      it 'does not raise any error' do
        expect { subject }.not_to raise_error
      end
    end
  end

  context '#validate_slots_count' do
    context 'when number of slots is less than minimum_slots_count_per_driving_lesson' do
      let!(:slot_1) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 23, 30, 0))
      end

      let!(:slot_2) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 4, 0, 0, 0))
      end

      let!(:slot_3) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 4, 0, 30, 0))
      end

      let!(:schedule_settings) do
        create(:schedule_settings,
               driving_school: driving_school,
               minimum_slots_count_per_driving_lesson: 4)
      end

      it 'raises BadRequest error with proper message' do
        expect { subject }.to raise_error(
          ActionController::BadRequest, 'Driving Lesson should last at least 120 minutes.'
        )
      end
    end

    context 'when number of slots is more than minimum_slots_count_per_driving_lesson' do
      let!(:slot_1) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 23, 30, 0))
      end

      let!(:slot_2) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 4, 0, 0, 0))
      end

      let!(:slot_3) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 4, 0, 30, 0))
      end

      let!(:schedule_settings) do
        create(:schedule_settings,
               driving_school: driving_school,
               maximum_slots_count_per_driving_lesson: 2)
      end

      it 'raises BadRequest error with proper message' do
        expect { subject }.to raise_error(
          ActionController::BadRequest, 'Driving Lesson should last less than 60 minutes.'
        )
      end
    end
  end

  context '#validate_breaks_between_nearest_lessons' do
    context 'when there will be left two available slots after driving lesson ' \
            'and shortest driving lesson lasts 3 slots' do
      let(:slots) { Slot.find([slot_1, slot_2, slot_3, slot_4].pluck(:id)) }
      let!(:slot_1) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
      end

      let!(:slot_2) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 13, 0, 0))
      end

      let!(:slot_3) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 13, 30, 0))
      end

      let!(:slot_4) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 14, 0o0, 0))
      end

      let!(:available_slot_1) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 14, 30, 0))
      end

      let!(:available_slot_2) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 15, 0o0, 0))
      end

      let!(:booked_slot) do
        create(:slot,
               :booked,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 15, 30, 0))
      end

      let!(:schedule_settings) do
        create(:schedule_settings,
               driving_school: driving_school,
               minimum_slots_count_per_driving_lesson: 3)
      end

      it 'raises BadRequest error with proper message' do
        expect { subject }.to raise_error(
          ActionController::BadRequest, 'You should leave enough time for next lesson to take place.'
        )
      end
    end

    context 'when there will be left one available slots before driving lesson
            and shortest driving lesson can last 2 slots' do
      let(:slots) { Slot.find([slot_1, slot_2].pluck(:id)) }
      let!(:booked_slot) do
        create(:slot,
               :booked,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 11, 30, 0))
      end
      let!(:available_slot) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 12, 0, 0))
      end
      let!(:slot_1) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
      end

      let!(:slot_2) do
        create(:slot,
               employee_driving_school: employee_driving_school,
               start_time: DateTime.new(2050, 2, 3, 13, 0, 0))
      end


      let!(:schedule_settings) do
        create(:schedule_settings,
               driving_school: driving_school,
               minimum_slots_count_per_driving_lesson: 2)
      end

      it 'raises BadRequest error with proper message' do
        expect { subject }.to raise_error(
          ActionController::BadRequest, 'You should leave enough time for previous lesson to take place.'
        )
      end
    end
  end
end
