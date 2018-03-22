class DrivingLessons::CancelService
  def initialize(current_user, driving_lesson)
    @current_user = current_user
    @driving_lesson = driving_lesson
  end

  def call
    DrivingLesson.transaction do
      driving_lesson.slots = Slot.none
      driving_lesson.cancel!
    end
  end

  private

  attr_accessor :current_user, :driving_lesson
end
