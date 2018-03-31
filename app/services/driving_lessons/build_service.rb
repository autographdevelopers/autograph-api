class DrivingLessons::BuildService
  def initialize(current_user, employee, student, driving_school, slots)
    @current_user = current_user
    @employee = employee
    @student = student
    @driving_school = driving_school
    @slots = slots

    validate_slots
  end

  def call
    driving_lesson = DrivingLesson.new(
      employee: employee,
      student: student,
      driving_school: driving_school,
      start_time: earliest_slot_start_time
    )

    driving_lesson.slots = slots

    driving_lesson
  end

  private

  attr_accessor :current_user, :employee, :student, :driving_school, :slots

  def validate_slots
    slot_start_times = slots.map(&:start_time).sort

    (slot_start_times.length - 1).times do |i|
      if (slot_start_times[i] + 30.minutes) != slot_start_times[i+1]
        raise ActionController::BadRequest.new('Slots must be half an hour apart')
      end
    end
  end

  def earliest_slot_start_time
    slots.min_by(&:start_time).start_time
  end
end
