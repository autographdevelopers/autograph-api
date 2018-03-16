class ScheduleSlotsJob < ApplicationJob
  queue_as :default

  def perform
    Slots::ScheduleService.new()
  end
end
