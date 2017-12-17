class StudentDrivingSchool < ApplicationRecord
  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2 }

  # == Relations ==============================================================
  belongs_to :student, optional: true
  belongs_to :driving_school
  has_one :invitation, as: :invitable

  # == Validations ============================================================
  validates :status, presence: true
end
