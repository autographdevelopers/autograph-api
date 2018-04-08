describe DrivingLesson do
  context 'relations' do
    it { should belong_to(:driving_school) }
    it { should belong_to(:employee) }
    it { should belong_to(:student) }
    it { should have_many(:slots) }
  end

  context 'validations' do
    it { should validate_presence_of(:start_time) }
  end

  context 'callbacks' do
    context 'after_create' do
      subject { build(:driving_lesson) }

      context '#broadcast_changed_driving_lesson' do
        it 'schedules BroadcastChangedSlotJob' do
          expect(BroadcastChangedDrivingLessonJob).to receive(:perform_later)

          subject.save!
        end
      end
    end

    context 'after cancel' do
      subject { create(:driving_lesson) }

      context '#broadcast_changed_driving_lesson' do
        it 'schedules BroadcastChangedSlotJob' do
          expect(BroadcastChangedDrivingLessonJob).to receive(:perform_later).with(subject.id)

          subject.cancel!
        end
      end
    end
  end
end
