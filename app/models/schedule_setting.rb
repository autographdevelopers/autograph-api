class ScheduleSetting < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :driving_school

  # == Validations ============================================================
  validates :holidays_enrollment_enabled, :last_minute_booking_enabled, inclusion: { in: [true, false] }
end
