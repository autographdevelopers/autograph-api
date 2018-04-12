class DrivingCourse < ApplicationRecord
  SLOTS_TO_HOURS_CONVERSION_RATE = 0.5

  # == Enumerators ============================================================
  enum category_type: { b: 0 }

  # == Relations ==============================================================
  belongs_to :student_driving_school

  # == Validations ============================================================
  validates :available_hours, :category_type, presence: true
  validates :available_hours, numericality: {
    only_integer: true, greater_than_or_equal_to: 0
  }

  def used_hours
    active_slots.past.count * SLOTS_TO_HOURS_CONVERSION_RATE
  end

  def booked_hours
    active_slots.future.count * SLOTS_TO_HOURS_CONVERSION_RATE
  end

  private

  def active_slots
    Slot.includes(:driving_lesson)
        .where(driving_lessons: {
          driving_school_id: student_driving_school.driving_school_id,
          student_id: student_driving_school.student_id,
          status: :active
        })
  end
end
