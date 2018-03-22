class DrivingLesson < ApplicationRecord
  # == Extensions =============================================================
  include AASM

  # == Relations ==============================================================
  belongs_to :student
  belongs_to :employee
  belongs_to :driving_school
  has_many :slots

  # == Enumerators ============================================================
  enum status: { active: 0, canceled: 1 }

  # == Validations ============================================================
  validates :start_time, presence: true

  # == Scopes =================================================================
  scope :upcoming, -> { where('driving_lessons.start_time > ?', Time.now) }

  # == State Machine ==========================================================
  aasm column: :status, enum: true do
    state :active, initial: true
    state :active, :canceled

    event :cancel do
      transitions from: :active, to: :canceled, guard: [:start_time_in_future?]
    end
  end

  private

  def start_time_in_future?
    start_time >= Time.now
  end
end
