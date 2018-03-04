class Slot < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :employee_driving_school
  belongs_to :driving_lesson, optional: true

  # == Validations ============================================================
  validates :start_time, presence: true
end
