class EmployeeDrivingSchool < ApplicationRecord
  # == Enumerators ============================================================
  enum status: { pending: 0, active: 1, archived: 2 }

  # == Relations ==============================================================
  belongs_to :employee, optional: true
  belongs_to :driving_school
  has_one :employee_privilege_set
  has_one :employee_notifications_settings_set
  has_one :invitation, as: :invitable

  # == Validations ============================================================
  validates :status, presence: true
end
