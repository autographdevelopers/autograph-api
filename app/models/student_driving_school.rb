class StudentDrivingSchool < ApplicationRecord
  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2 }

  # == Relations ==============================================================
  belongs_to :student
  belongs_to :driving_school

  # == Validations ============================================================
  validates :status, presence: true
end
