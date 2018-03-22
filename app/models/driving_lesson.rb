class DrivingLesson < ApplicationRecord
  # == Extensions =============================================================
  include AASM

  # == Relations ==============================================================
  belongs_to :student_driving_school
  belongs_to :employee_driving_school
  has_many :slots

  # == Enumerators ============================================================
  enum status: { active: 0, canceled: 1 }

  # == Validations ============================================================
  validates :start_time, presence: true

  # == Scopes =================================================================
  scope :by_user_driving_school, ->(student_id:, employee_id:, driving_school_id:) {
    if student_id.present?
      where(student_driving_schools: {
              student_id: student_id,
              driving_school_id: driving_school_id,
              status: :active
            }).includes(:student_driving_school)
    elsif employee_id.present?
      where(employee_driving_schools: {
              employee_id: employee_id,
              driving_school_id: driving_school_id,
              status: :active
            }).includes(:employee_driving_school)
    end
  }

  scope :by_driving_school, ->(driving_school_id) {
    where(student_driving_schools: {
            driving_school_id: driving_school_id
          }).includes(:student_driving_school)
  }

  scope :upcoming, -> { where('driving_lessons.start_time > ?', Time.now) }

  # == State Machine ==========================================================
  aasm column: :status, enum: true do
    state :active, initial: true
    state :active, :canceled

    event :cancel do
      transitions from: :active, to: :canceled, guard: [:start_time_in_future?]
    end
  end

  private

  def start_time_in_future?
    start_time >= Time.now
  end
end
