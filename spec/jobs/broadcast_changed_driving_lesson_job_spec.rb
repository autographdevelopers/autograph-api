describe BroadcastChangedDrivingLessonJob do
  let(:employee_driving_school) { create(:employee_driving_school) }
  let!(:driving_lesson) do
    create(:driving_lesson,
           employee: employee_driving_school.employee,
           driving_school: employee_driving_school.driving_school)
  end
  let!(:slot_1) do
    create(:slot,
           driving_lesson: driving_lesson,
           employee_driving_school: employee_driving_school,
           start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
  end

  let!(:slot_2) do
    create(:slot,
           driving_lesson: driving_lesson,
           employee_driving_school: employee_driving_school,
           start_time: DateTime.new(2050, 2, 3, 12, 0, 0))
  end

  let!(:slot_3) do
    create(:slot,
           driving_lesson: driving_lesson,
           employee_driving_school: employee_driving_school,
           start_time: DateTime.new(2050, 2, 3, 13, 0, 0))
  end

  context '#perform' do
    after { BroadcastChangedDrivingLessonJob.new.perform(driving_lesson.id) }

    it 'broadcasts DrivingLesson record to channel' do
      server = double

      expect(ActionCable).to receive(:server).and_return(server)

      expect(server).to receive(:broadcast).with(
        "slots_#{employee_driving_school.id}",
        hash_including(
          type: 'DRIVING_LESSON_CHANGED', driving_lesson: kind_of(Hash)
        )
      )
    end
  end
end
