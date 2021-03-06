class DrivingLessons::CancelService
  def initialize(current_user, driving_lesson)
    current_user = current_user
    @driving_lesson = driving_lesson
  end

  def call
    DrivingLesson.transaction do
      increment_student_driving_hours
      driving_lesson.slots = Slot.none # TODO check if it even works
      driving_lesson.cancel!
    end
  end

  private

  attr_accessor :current_user, :driving_lesson

  def increment_student_driving_hours
    slots_count = driving_lesson.slots.count
    driving_lesson.course_participation_detail.increment!(:available_slot_credits, slots_count)
    driving_lesson.course_participation_detail.refresh_slot_counts!
  end
end
