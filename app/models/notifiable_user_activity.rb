class NotifiableUserActivity < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :activity
  belongs_to :user

  # == Validations ============================================================
  validates :activity, uniqueness: { scope: :user }

  # == Validations ============================================================

  scope :with_activity_type, lambda { |activity_type|
    references(:activity).where(activities: { activity_type: activity_type })
  }

  scope :with_from_date, ->(value) { references(:activity).where('activities.created_at >= ?', value) }
  scope :with_to_date, ->(value) { references(:activity).where('activities.created_at <= ?', value) }
end
