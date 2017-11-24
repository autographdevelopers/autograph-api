class EmployeeDrivingSchool < ApplicationRecord
  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2 }

  # == Relations ==============================================================
  belongs_to :employee
  belongs_to :driving_school
  has_one :employee_privilege_set

  # == Validations ============================================================
  validates :status, presence: true
end
