class DrivingLessons::BuildService
  def initialize(current_user, employee_driving_school, student, driving_school, slots, driving_course)
    @current_user = current_user
    @employee_driving_school = employee_driving_school
    @employee = employee_driving_school.employee
    @student = student
    @driving_school = driving_school
    @schedule_settings = driving_school.schedule_settings
    @slots = slots
    @driving_course = driving_course

    min_slots_count = schedule_settings.minimum_slots_count_per_driving_lesson
    max_slots_count = schedule_settings.maximum_slots_count_per_driving_lesson

    validate_slots_to_be_consecutive
    validate_slots_count(min_slots_count, max_slots_count)
    validate_available_slots_after_lesson(min_slots_count)
    validate_available_slots_before_lesson(min_slots_count)
  end

  def call
    driving_lesson = DrivingLesson.new(
      employee: employee,
      student: student,
      driving_school: driving_school,
      start_time: earliest_slot_start_time,
      driving_course: driving_course
    )

    driving_lesson.slots = slots

    driving_lesson
  end

  private

  attr_accessor :current_user, :employee, :student, :driving_school, :slots,
                :schedule_settings, :employee_driving_school, :driving_course

  def validate_slots_to_be_consecutive
    slot_start_times = slots.map(&:start_time).sort

    (slot_start_times.length - 1).times do |i|
      if (slot_start_times[i] + 30.minutes) != slot_start_times[i+1]
        raise ActionController::BadRequest, 'Slots must be half an hour apart'
      end
    end
  end

  def validate_slots_count(min_slots_count, max_slots_count)
    if slots.count < min_slots_count
      raise ActionController::BadRequest,
            "Driving Lesson should last at least #{slots_count_to_minutes(min_slots_count)}."
    elsif slots.count > max_slots_count
      raise ActionController::BadRequest,
            "Driving Lesson should last less than #{slots_count_to_minutes(max_slots_count)}."
    end
  end

  def validate_available_slots_after_lesson(min_slots_count)
    return if next_slot_blank?

    next_available_slots_count = employee_driving_school.slots
                                                        .available
                                                        .where(start_time: range_for_next_lesson(min_slots_count))
                                                        .count

    unless [0, min_slots_count].include? next_available_slots_count
      raise ActionController::BadRequest,
            'You should leave enough time for next lesson to take place.'
    end
  end

  def validate_available_slots_before_lesson(min_slots_count)
    return if previous_slot_blank?

    previous_available_slots_count = employee_driving_school.slots
                                                            .available
                                                            .where(start_time: range_for_previous_lesson(min_slots_count))
                                                            .count

    unless [0, min_slots_count].include? previous_available_slots_count
      raise ActionController::BadRequest,
            'You should leave enough time for previous lesson to take place.'
    end
  end

  def earliest_slot_start_time
    slots.min_by(&:start_time).start_time
  end

  def latest_slot_start_time
    slots.max_by(&:start_time).start_time
  end

  def slots_count_to_minutes(slots_count)
    "#{slots_count * 30} minutes"
  end

  def range_for_next_lesson(slots_count)
    (latest_slot_start_time + 30.minutes)..(latest_slot_start_time + slots_count * 30.minutes)
  end

  def range_for_previous_lesson(slots_count)
    (earliest_slot_start_time - slots_count * 30.minutes)..(earliest_slot_start_time - 30.minutes)
  end

  def next_slot_blank?
    !employee_driving_school.slots.available.exists?(
      start_time: latest_slot_start_time + 30.minutes
    )
  end

  def previous_slot_blank?
    !employee_driving_school.slots.available.exists?(
      start_time: earliest_slot_start_time - 30.minutes
    )
  end
end
