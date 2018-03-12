class EmployeeDrivingSchool < ApplicationRecord
  include AASM

  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2, rejected: 3 }

  # == Relations ==============================================================
  belongs_to :employee, optional: true
  belongs_to :driving_school
  has_one :employee_privilege_set
  has_one :employee_notifications_settings
  has_one :invitation, as: :invitable
  has_one :schedule
  has_many :driving_lessons
  has_many :slots

  # == Scopes =================================================================
  scope :eligible_for_change, -> {
    where(status: :active, driving_schools: { status: [:active] })
      .includes(:driving_school)
  }

  scope :eligible_for_viewing, -> {
    where(status: [:active, :pending], driving_schools: { status: [:active, :pending] })
      .includes(:driving_school)
  }

  # == Validations ============================================================
  validates :status, presence: true

  # == Callbacks ==============================================================
  after_create :create_schedule

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
  end
end
