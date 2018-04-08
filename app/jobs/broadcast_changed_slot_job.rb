class BroadcastChangedSlotJob < ApplicationJob
  queue_as :default

  def perform(slot_id)
    slot = Slot.find(slot_id)

    ActionCable.server.broadcast(
      build_channel_string(slot.employee_driving_school_id),
      type: 'SLOT_CHANGED',
      slot: JSON.parse(
        ApplicationController.renderer.render(
          partial: 'api/v1/slots/slot.json',
          locals: { slot: slot }
        )
      )
    )
  end
end
