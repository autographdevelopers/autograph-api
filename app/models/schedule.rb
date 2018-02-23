# Schedule keeps general information about employee schedule
# Basing on this model actual Slots are created
# slots_template example:
# {
#   monday: [1, 2, 3, 4, 5],
#   tuesday: [1, 2, 3, 4, 5],
#   wednesday: [11, 12, 13, 46, 47],
#   monday: [1, 2, 3, 4, 5],
#   monday: [1, 2, 3, 4, 5],
# }
# Numbers in arrays are mapped to hours, while creating
# actual slots

class Schedule < ApplicationRecord
  include ScheduleConstants

  # == Relations ==============================================================
  belongs_to :employee_driving_school

  # == Validations ============================================================
  validates :current_template, :new_template, :new_template_binding_from, :repetition_period_in_weeks, presence: true
  validates :repetition_period_in_weeks, inclusion: MIN_SCHEDULE_REPETITION_PERIOD..MAX_SCHEDULE_REPETITION_PERIOD
  validate :template_format

  def slots_template_format
    errors.add(:template, "has invalid weekday(s)") unless template_contains_valid_weekdays?
    errors.add(:template, "has invalid slot_start_times_id(s)") unless template_contains_valid_slot_start_times_ids?
  end

  private

  def template_contains_valid_weekdays?
    WEEKDAYS.sort == template.keys.sort
  end

  def template_contains_valid_slot_start_times_ids?
    template.each do |_, slot_start_times_ids|
      return false if (slot_start_times_ids - SLOT_START_TIMES.keys).any?
      return false if slot_start_times_ids.count != slot_start_times_ids.uniq.count
    end

    true
  end
end
