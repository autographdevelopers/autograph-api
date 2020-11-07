class CourseParticipationDetail < ApplicationRecord
  include Discard::Model

  SLOTS_TO_HOURS_CONVERSION_RATE = 0.5

  # == Relations ==============================================================
  belongs_to :student_driving_school
  belongs_to :driving_school
  belongs_to :course, counter_cache: true
  has_many :driving_lessons

  # == Enums ============================================================
  enum status: { active: 0 }, _prefix: :status

  # == Validations ============================================================
  validates :available_hours, numericality: {
    greater_than_or_equal_to: 0
  }
  validate :validate_available_hours

  validates :student_driving_school_id, uniqueness: { scope: [:course_id, :status, :discarded_at] }

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

  def validate_available_hours
    if available_hours.present? && !(available_hours % SLOTS_TO_HOURS_CONVERSION_RATE).zero?
      errors.add(:available_hours, 'must be divisible by 0.5')
    end
  end
end
