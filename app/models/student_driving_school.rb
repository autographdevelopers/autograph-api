class StudentDrivingSchool < ApplicationRecord
  include AASM

  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2, rejected: 3 }

  # == Relations ==============================================================
  belongs_to :student, optional: true
  belongs_to :driving_school
  has_one :invitation, as: :invitable
  has_many :course_participation_details
  has_one :avatar_placeholder_color,
          -> { avatar_placeholder },
          as: :colorable,
          class_name: 'ColorableColor'.freeze

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

  scope :searchTerm, ->(q) do
    where(%(
        users.name ILIKE :term
        OR users.surname ILIKE :term
        OR users.email ILIKE :term
        OR invitations.email ILIKE :term
        OR invitations.name ILIKE :term
        OR invitations.surname ILIKE :term
      ), term: "%#{q}%"
    )
  end

  scope :eligible_for_viewing, -> {
    where(status: [:active, :pending], driving_schools: { status: [:active] })
      .includes(:driving_school)
  }

  # == Validations ============================================================
  validates :status, presence: true
  # validates :student_id, uniqueness: true, scope: :driving_school_id

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
    student&.full_name || invitation.full_name
  end

  def student_email
    student&.email || invitation.email
  end
end
