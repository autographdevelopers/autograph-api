class StudentDrivingSchool < ApplicationRecord
  include AASM

  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2, rejected: 3 }

  # == Relations ==============================================================
  belongs_to :student
  belongs_to :driving_school
  has_many :course_participation_details

  # == Scopes =================================================================
  scope :active_with_active_driving_school, -> {
    where(status: :active, driving_schools: { status: :active })
      .includes(:driving_school)
  }

  scope :pending_with_active_driving_school, -> {
    where(status: :pending, driving_schools: { status: :active })
        .includes(:driving_school)
  }

  scope :archived_with_active_driving_school, -> {
    where(status: :archived, driving_schools: { status: :active })
        .includes(:driving_school)
  }

  scope :ones_not_assigned_to_course, -> (course_id) {
    left_joins(:course_participation_details).where.not(course_participation_details: { course_id: course_id })
  }

  scope :with_status_in_active_school, -> (status) {
    where(status: status, driving_schools: { status: :active })
        .includes(:driving_school)
  }

  scope :search, ->(q) do
    where(%(
        users.name ILIKE :term
        OR users.surname ILIKE :term
        OR users.email ILIKE :term
      ), term: "%#{q}%"
    )
  end

  scope :eligible_for_viewing, -> {
    where(status: [:active, :pending], driving_schools: { status: [:active] })
      .includes(:driving_school).references(:driving_school).where(driving_schools: { discarded_at: nil })
  }

  # == Validations ============================================================
  validates :status, presence: true
  validates :student_id, uniqueness: { scope: :driving_school_id }

  # == State Machine ==========================================================
  aasm column: :status, enum: true do
    state :pending, initial: true
    state :pending, :active, :archived, :rejected

    event :activate do
      transitions from: :pending, to: :active
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :archive do
      transitions to: :archived
    end
  end

  def student_full_name
    student.full_name
  end

  def student_email
    student.email
  end
end
