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
  validates :available_slot_credits, :booked_slots_count, :used_slots_count, numericality: {
    greater_than_or_equal_to: 0,
    # only_integer: true dlaczego nie dziala ?
  }

  validates :student_driving_school_id, uniqueness: { scope: [:course_id, :status, :discarded_at] }


  def refresh_slot_counts!
    # TODO consider moving slots calculations to bg jobs
    update_attributes!(
      booked_slots_count: active_slots.merge(Slot.future).count,
      used_slots_count: active_slots.merge(Slot.past).count,
    )
  end

  private

  def active_slots
    driving_lessons.left_joins(:slots).where(driving_lessons: { status: :active })
    # TODO rethink
    # Slot.includes(:driving_lesson)
    #     .where(driving_lessons: {
    #              driving_school_id: student_driving_school.driving_school_id,
    #              student_id: student_driving_school.student_id,
    #              status: :active
    #            })
  end
end
