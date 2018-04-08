describe BroadcastChangedSlotJob do
  let(:employee_driving_school) { create(:employee_driving_school) }
  let!(:slot) do
    create(:slot,
           employee_driving_school: employee_driving_school,
           start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
  end

  context '#perform' do
    after { BroadcastChangedSlotJob.new.perform(slot.id) }

    it 'broadcasts DrivingLesson record to channel' do
      server = double

      expect(ActionCable).to receive(:server).and_return(server)

      expect(server).to receive(:broadcast).with(
        "slots_#{employee_driving_school.id}",
        hash_including(
          type: 'SLOT_CHANGED', slot: kind_of(Hash)
        )
      )
    end
  end
end
