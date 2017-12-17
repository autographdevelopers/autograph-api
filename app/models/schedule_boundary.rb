class ScheduleBoundary < ApplicationRecord
  # == Enumerators ============================================================
  enum weekday: { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }

  # == Relations ==============================================================
  belongs_to :driving_school

  # == Validations ============================================================
  validates :start_time, :end_time, :weekday, presence: true
  validate :end_time_not_to_be_before_start_time
  validate :times_to_be_in_proper_format

  # == Instance Methods =======================================================

  private

  def end_time_not_to_be_before_start_time
    if start_time && end_time && start_time.utc.strftime('%H%M%S%N') >= end_time.utc.strftime('%H%M%S%N')
      errors.add(:end_time, "can't be before start time")
    end
  end

  def times_to_be_in_proper_format
    errors.add(:start_time, 'must start either at half or full hour') if start_time && !valid_time?(start_time)
    errors.add(:end_time, 'must start either at half or full hour') if end_time && !valid_time?(end_time)
  end

  def valid_time?(time)
    (time.to_datetime.minute % 30) == 0
  end
end
