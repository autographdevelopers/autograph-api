class Slot < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :employee_driving_school
  belongs_to :driving_lesson, optional: true

  # == Validations ============================================================
  validates :start_time, presence: true

  # == Scopes =================================================================
  scope :booked,    -> { where.not(driving_lesson: nil) }
  scope :available, -> { where(driving_lesson: nil) }
  scope :future,    -> { where('start_time > ?', Time.now) }
  scope :by_start_time, ->(from, to) {
    where("start_time >= ? AND start_time <= ?", from, to)
  }
end
