class CustomActivityType < ApplicationRecord
  include Discard::Model

  belongs_to :driving_school

  TARGET_TYPES = [InventoryItem.name]

  attr_accessor :test_activity

  validates :name,
            :message_template,
            :notification_receivers,
            :datetime_input_config,
            :text_note_input_config,
            presence: true

  validates :target_type,
            inclusion: { in: TARGET_TYPES },
            allow_nil: true

  validate :message_template_contains_valid_interpolations

  enum notification_receivers: { all_employees: 0 }
  enum datetime_input_config: { none: 0, optional: 1, required: 2 }, _prefix: :datetime_input
  enum text_note_input_config: { none: 0, optional: 1, required: 2 }, _prefix: :text_note_input

  def init_test_activity(user: test_user)
    self.test_activity = Activity.new(
      custom_activity_type: self,
      target: target_type ? test_target : nil,
      driving_school: driving_school,
      user: user
    )
  end

  private

  def test_target
    self.target_type.constantize.find_by(driving_school: driving_school) || self.target_type.constantize.build_test_target
  end

  def test_user
    User.build_test_user
  end

  def message_template_contains_valid_interpolations
    return unless message_template

    self.test_activity ||= init_test_activity
    self.test_activity.determine_message_from_custom_type!
  rescue KeyError => e
    errors.add(:message_template, "Message template contains invalid key: #{e.key}")
  end
end
