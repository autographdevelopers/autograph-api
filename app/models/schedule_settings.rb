class ScheduleSettings < ApplicationRecord
  include ScheduleConstants

  # == Relations ==============================================================
  belongs_to :driving_school

  # == Validations ============================================================
  validates :valid_time_frames, :minimum_slots_count_per_driving_lesson,
            :maximum_slots_count_per_driving_lesson, presence: true
  validates :minimum_slots_count_per_driving_lesson, :maximum_slots_count_per_driving_lesson,
            numericality: { only_integer: true, greater_than: 0 }
  validates :minimum_slots_count_per_driving_lesson, numericality:
            { less_than_or_equal_to: :maximum_slots_count_per_driving_lesson }
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
end
