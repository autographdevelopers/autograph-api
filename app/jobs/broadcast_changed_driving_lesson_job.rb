class BroadcastChangedDrivingLessonJob < ApplicationJob
  queue_as :default

  def perform(driving_lesson_id)
    driving_lesson = nil
    DrivingLesson.uncached do
      driving_lesson = DrivingLesson.find(driving_lesson_id)
    end
    p '##########################'
    p '##########################'
    p '##########################'
    p 'BroadcastChangedDrivingLessonJob'
    p driving_lesson
    p '##########################'
    p '##########################'
    p '##########################'
    p '##########################'
    p '##########################'

    employee_driving_school = EmployeeDrivingSchool.find_by(
        employee: driving_lesson.employee,
        driving_school: driving_lesson.driving_school
    )

    ActionCable.server.broadcast(
      build_channel_string(employee_driving_school.id),
      type: 'DRIVING_LESSON_CHANGED',
      driving_lesson: JSON.parse(
        ApplicationController.renderer.render(
          template: 'api/v1/driving_lessons/create.json',
          locals: { driving_lesson: driving_lesson }
        )
      )
    )
  end
end
