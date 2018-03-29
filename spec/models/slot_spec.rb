describe Slot do
  context 'relations' do
    it { should belong_to(:employee_driving_school) }
    it { should belong_to(:driving_lesson) }
  end

  context 'validations' do
    it { should validate_presence_of(:start_time) }
  end

  context 'instance methods' do
    let(:user) { create(:user) }
    subject do
      create(:slot,
             employee_driving_school: create(:employee_driving_school)
      )
    end

    context '#lock_during_booking' do
      it 'sets release_at and locking_user' do
        subject.lock_during_booking(user)

        expect(subject.release_at).to be_within(1.second).of(Slot::BOOKING_LOCK_PERIOD.from_now)
        expect(subject.locking_user).to be user
      end

      it 'schedules BroadcastChangedSlotJob' do
        expect(BroadcastChangedSlotJob).to receive(:perform_later).with(subject.id)
        subject.lock_during_booking(user)
      end
    end

    context '#unlock_during_booking' do
      it 'sets release_at and locking_user' do
        subject.unlock_during_booking

        expect(subject.release_at).to be nil
        expect(subject.locking_user).to be nil
      end

      it 'schedules BroadcastChangedSlotJob' do
        expect(BroadcastChangedSlotJob).to receive(:perform_later).with(subject.id)
        subject.unlock_during_booking
      end
    end
  end
end
