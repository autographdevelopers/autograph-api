class DrivingCourse < ApplicationRecord
  # == Enumerators ============================================================
  enum category_type: { b: 0 }

  # == Relations ==============================================================
  belongs_to :student_driving_school

  # == Validations ============================================================
  validates :available_hours, :booked_hours, :used_hours, :category_type,
            presence: true
  validates :available_hours, :booked_hours, :used_hours, numericality: {
    only_integer: true, greater_than_or_equal_to: 0
  }
end
