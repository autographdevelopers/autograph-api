# Schedule keeps general information about employee schedule
# Basing on this model actual Slots are created
# new_template and current_template example:
# {
#   monday: [1, 2, 3, 4, 5],
#   tuesday: [1, 2, 3, 4, 5],
#   ...
#   sunday: [1, 3, 5]
# }
# Numbers in arrays are mapped to hours, while creating
# actual slots

class Schedule < ApplicationRecord
  include ScheduleConstants

  # == Relations ==============================================================
  belongs_to :employee_driving_school

  # == Validations ============================================================
  validates :current_template, :new_template, :repetition_period_in_weeks, presence: true
  validates :repetition_period_in_weeks, inclusion: MIN_SCHEDULE_REPETITION_PERIOD..MAX_SCHEDULE_REPETITION_PERIOD
  validate :current_template_format
  validate :new_template_format
  validate :new_template_binding_from_to_be_in_the_future

  def new_template_binding_from_to_be_in_the_future
    if new_template_binding_from.present? &&  new_template_binding_from_changed? && new_template_binding_from <= Date.today
      errors.add(:new_template_binding_from, "must be in the future")
    end
  end

  def current_template_format
    if current_template.present?
      errors.add(:current_template, "has invalid weekday(s)") unless template_contains_valid_weekdays?(current_template)
      errors.add(:current_template, "has invalid slot_start_times_id(s)") unless template_contains_valid_slot_start_times_ids?(current_template)
    end
  end

  def new_template_format
    if new_template.present?
      errors.add(:new_template, "has invalid weekday(s)") unless template_contains_valid_weekdays?(new_template)
      errors.add(:new_template, "has invalid slot_start_times_id(s)") unless template_contains_valid_slot_start_times_ids?(new_template)
    end
  end

  private

  def template_contains_valid_weekdays?(template)
    WEEKDAYS.keys.sort == template.keys.sort
  end

  def template_contains_valid_slot_start_times_ids?(template)
    template.each do |_, slot_start_times_ids|
      return false if (slot_start_times_ids - SLOT_START_TIMES.keys).any?
      return false if slot_start_times_ids.count != slot_start_times_ids.uniq.count
    end

    true
  end
end
