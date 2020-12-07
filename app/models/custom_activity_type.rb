class CustomActivityType < ApplicationRecord
  belongs_to :driving_school

  TARGET_TYPES = [InventoryItem.name]

  validates :name,
            :message_template,
            :notification_receivers,
            :datetime_input_config,
            :text_note_input_config,
            presence: true

  validates :target_type, inclusion: { in: TARGET_TYPES }, allow_nil: true

  enum notification_receivers: { all_employees: 0 }
  enum datetime_input_config: { none: 0, optional: 1, required: 2 }, _prefix: :datetime_input
  enum text_note_input_config: { none: 0, optional: 1, required: 2 }, _prefix: :text_note_input
end
