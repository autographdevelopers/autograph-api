class DrivingLesson < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :student_driving_school
  belongs_to :employee_driving_school
  has_many :slots

  # == Validations ============================================================
  validates :start_time, presence: true
end
