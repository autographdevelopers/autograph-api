class ScheduleSettings < ApplicationRecord
  include ScheduleConstants

  # == Relations ==============================================================
  belongs_to :driving_school

  # == Callbacks ==============================================================
  before_save :update_schedules, if: :will_save_change_to_booking_advance_period_in_weeks?

  # == Validations ============================================================
  validates :valid_time_frames, :minimum_slots_count_per_driving_lesson,
            :maximum_slots_count_per_driving_lesson, :booking_advance_period_in_weeks,
            presence: true
  validates :booking_advance_period_in_weeks, inclusion: MIN_SCHEDULE_REPETITION_PERIOD..MAX_SCHEDULE_REPETITION_PERIOD
  validates :minimum_slots_count_per_driving_lesson, :maximum_slots_count_per_driving_lesson,
            numericality: { only_integer: true, greater_than: 0 }
  validates :minimum_slots_count_per_driving_lesson,
            numericality: { less_than_or_equal_to: :maximum_slots_count_per_driving_lesson },
            if: -> { maximum_slots_count_per_driving_lesson.present? }
  validates :holidays_enrollment_enabled, :last_minute_booking_enabled,
            :can_student_book_driving_lesson, inclusion: { in: [true, false] }
  validate :valid_time_frames_format

  def valid_time_frames_format
    return unless valid_time_frames.present?

    errors.add(:valid_time_frames, "has invalid weekday(s)") unless valid_time_frames_contains_valid_weekdays?(valid_time_frames)
    errors.add(:valid_time_frames, "has invalid slot_start_times_id(s)") unless valid_time_frames_contains_valid_slot_start_times_ids?(valid_time_frames)
  end

  private

  def valid_time_frames_contains_valid_weekdays?(valid_time_frames)
    WEEKDAYS.keys.sort == valid_time_frames.keys.sort
  end

  def valid_time_frames_contains_valid_slot_start_times_ids?(valid_time_frames)
    valid_time_frames.each do |_, slot_start_times_ids|
      return false if (slot_start_times_ids - SLOT_START_TIMES.keys).any?
      return false if slot_start_times_ids.count != slot_start_times_ids.uniq.count
    end

    true
  end

  def update_schedules
    employee_driving_schools = driving_school.employee_driving_schools
                                             .active
                                             .where(employee_privileges: { is_driving: true })
                                             .includes(:employee_privileges, :schedule)

    employee_driving_schools.each do |employee_driving_school|
      Slots::RescheduleAllService.new(
        employee_driving_school.schedule
      ).call
    end
  end
end
