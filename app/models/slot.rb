class Slot < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :employee_driving_school

  # == Validations ============================================================
  validates :start_time, presence: true
end
