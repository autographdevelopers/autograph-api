class Slot < ApplicationRecord
  BOOKING_LOCK_PERIOD = 2.minutes.freeze

  # == Relations ==============================================================
  belongs_to :employee_driving_school
  belongs_to :driving_lesson, optional: true
  belongs_to :locking_user, optional: true, class_name: 'User'

  # == Validations ============================================================
  validates :start_time, presence: true

  # == Scopes =================================================================
  scope :booked,        -> { where.not(driving_lesson: nil) }
  scope :available,     -> { where(driving_lesson: nil) }
  scope :future,        -> { where('start_time > ?', Time.now) }
  scope :unlocked,      -> { where('release_at < ? OR release_at IS NULL', Time.now) }
  scope :locked,        -> { where('release_at > ?', Time.now) }
  scope :by_start_time, ->(from, to) {
    where("start_time >= ? AND start_time <= ?", from, to)
  }
  scope :employee_id, ->(value) { where(employee_driving_schools: { employee_id: value }) }

  # == Instance Methods =======================================================
  def lock_during_booking(user)
    release_at = user.locked_slots.locked.minimum('release_at') || BOOKING_LOCK_PERIOD.from_now
    update(release_at: release_at, locking_user: user)
    BroadcastChangedSlotJob.perform_later(id)
  end

  def unlock_during_booking
    update(release_at: nil, locking_user: nil)
    BroadcastChangedSlotJob.perform_later(id)
  end
end
