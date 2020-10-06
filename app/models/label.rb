class Label < ApplicationRecord
  has_many :labelable_labels
  has_many :labelables, through: :labelable_labels

  enum purpose: { course_category: 0 }, _prefix: :purpose

  scope :prebuilt, -> { where(prebuilt: true) }

  scope :label_ids, ->(label_ids) { where(id: label_ids) }
  scope :include_prebuilts_for_purpose, -> (purpose) {
    where(purpose: purpose, prebuilt: true)
  }
end
