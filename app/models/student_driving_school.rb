class StudentDrivingSchool < ApplicationRecord
  include AASM

  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2, rejected: 3 }

  # == Relations ==============================================================
  belongs_to :student, optional: true
  belongs_to :driving_school
  has_one :invitation, as: :invitable
  has_many :driving_courses
  has_many :driving_lessons

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
  end
end
