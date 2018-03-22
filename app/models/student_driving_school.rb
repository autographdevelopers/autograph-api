class StudentDrivingSchool < ApplicationRecord
  include AASM

  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2, rejected: 3 }

  # == Relations ==============================================================
  belongs_to :student, optional: true
  belongs_to :driving_school
  has_one :invitation, as: :invitable
  has_one :driving_course

  # == Callbacks ==============================================================
  after_create :create_driving_course

  # == Scopes =================================================================
  scope :active_with_active_driving_school, -> {
    where(status: :active, driving_schools: { status: :active })
      .includes(:driving_school)
  }

  scope :eligible_for_viewing, -> {
    where(status: [:active, :pending], driving_schools: { status: [:active] })
      .includes(:driving_school)
  }

  # == Validations ============================================================
  validates :status, presence: true

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
end
