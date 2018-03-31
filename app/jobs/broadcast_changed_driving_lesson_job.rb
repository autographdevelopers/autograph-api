class BroadcastChangedDrivingLessonJob < ApplicationJob
  queue_as :default

  def perform(driving_lesson_id)
    driving_lesson = DrivingLesson.find(driving_lesson_id)

    build_channel_strings(driving_lesson.slots).uniq.each do |channel|
      ActionCable.server.broadcast(
        channel,
        type: 'DRIVING_LESSON_CHANGED',
        driving_lesson: ApplicationController.renderer.render(
          template: 'api/v1/driving_lessons/create.json',
          locals: { driving_lesson: driving_lesson }
        )
      )
    end
  end

  private

  def build_channel_strings(slots)
    slots.map do |slot|
      build_channel_string(slot.employee_driving_school_id)
    end
  end
end
