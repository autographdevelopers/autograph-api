class Schedule < ApplicationRecord
  MIN_SCHEDULE_REPETITION_PERIOD = 1.freeze
  MAX_SCHEDULE_REPETITION_PERIOD = 26.freeze

  # == Relations ==============================================================
  belongs_to :employee_driving_school

  # == Validations ============================================================
  validates :current_template, :new_template, :new_template_binding_from, :repetition_period_in_weeks, presence: true
  validates :repetition_period_in_weeks, inclusion: MIN_SCHEDULE_REPETITION_PERIOD..MAX_SCHEDULE_REPETITION_PERIOD
end
