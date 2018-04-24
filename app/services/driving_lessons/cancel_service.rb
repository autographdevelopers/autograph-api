class DrivingLessons::CancelService
  def initialize(current_user, driving_lesson)
    @current_user = current_user
    @driving_lesson = driving_lesson
  end

  def call
    DrivingLesson.transaction do
      increment_student_driving_hours
      driving_lesson.slots = Slot.none
      driving_lesson.cancel!
    end
  end

  private

  attr_accessor :current_user, :driving_lesson

  def increment_student_driving_hours
    student = driving_lesson.student
    driving_school = driving_lesson.driving_school
    slots_count = driving_lesson.slots.count

    StudentDrivingSchool.find_by!(student: student, driving_school: driving_school)
                        .driving_course.increment(:available_hours, slots_count * 0.5)
  end
end
