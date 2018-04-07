class DrivingLesson < ApplicationRecord
  # == Extensions =============================================================
  include AASM

  # == Relations ==============================================================
  belongs_to :student
  belongs_to :employee
  belongs_to :driving_school
  has_many :slots
  has_many :activities, as: :target

  # == Enumerators ============================================================
  enum status: { active: 0, canceled: 1 }

  # == Callbacks ==============================================================
  after_create :broadcast_changed_driving_lesson

  # == Validations ============================================================
  validates :start_time, presence: true

  # == Scopes =================================================================
  scope :upcoming, -> { where('driving_lessons.start_time > ?', Time.now) }
  scope :past, -> { where('driving_lessons.start_time < ?', Time.now) }
  scope :student_id, ->(value) { where(student_id: value) }
  scope :employee_id, ->(value) { where(employee_id: value) }
  scope :driving_lessons_ids, ->(value) { where(id: value) }

  # == State Machine ==========================================================
  aasm column: :status, enum: true do
    state :active, initial: true
    state :active, :canceled

    event :cancel, after: :broadcast_changed_driving_lesson do
      transitions from: :active, to: :canceled, guard: [:start_time_in_future?]
    end
  end

  private

  def start_time_in_future?
    start_time > Time.now
  end

  def broadcast_changed_driving_lesson
    BroadcastChangedDrivingLessonJob.perform_later(id)
  end
end
