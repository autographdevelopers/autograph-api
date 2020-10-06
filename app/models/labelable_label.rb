class LabelableLabel < ApplicationRecord
  # == Associations ==========================================================
  belongs_to :labelable, polymorphic: true
  belongs_to :label

  # == Nested attributes ==========================================================
  accepts_nested_attributes_for :label

  # == Delegates ==========================================================
  delegate :name,
  :description,
  :purpose,
  :prebuilt, to: :label

  # == Scopes ==========================================================
  scope :by_label_purpose, ->(purpose) { includes(:label).references(:label).where(labels: { purpose: purpose }) }
end
