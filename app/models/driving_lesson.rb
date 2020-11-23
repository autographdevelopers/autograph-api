class DrivingLesson < ApplicationRecord
  # == Extensions =============================================================
  include AASM

  # == Relations ==============================================================
  belongs_to :student
  belongs_to :employee
  belongs_to :driving_school
  belongs_to :course_participation_detail
  has_many :slots
  has_many :lesson_notes

  # == Enumerators ============================================================
  enum status: { active: 0, canceled: 1 }

  # == Callbacks ==============================================================
  after_create :decrement_available_hours_credit
  after_create :schedule_job_for_refreshing_counts_after_lesson_take_place
  after_commit :broadcast_changed_driving_lesson

  # == Validations ============================================================
  validates :start_time, presence: true

  # == Scopes =================================================================
  scope :upcoming, -> { where('driving_lessons.start_time > ?', Time.now) }
  scope :past, -> { where('driving_lessons.start_time < ?', Time.now) }
  scope :student_id, ->(value) { where(student_id: value) }
  scope :employee_id, ->(value) { where(employee_id: value) }
  scope :course_participation_detail_id, ->(value) { where(course_participation_detail_id: value) }
  scope :driving_lessons_ids, ->(value) { where(id: value) }
  scope :from_date_time, ->(value) { where('driving_lessons.start_time > ?', value) }
  scope :to_date_time, ->(value) { where('driving_lessons.start_time < ?', value) }

  # == State Machine ==========================================================
  aasm column: :status, enum: true do
    state :active, initial: true
    state :active, :canceled

    event :cancel do
      transitions from: :active, to: :canceled, guard: [:start_time_in_future?], after: Proc.new {|*args| Courses::RefreshSlotCountsJob.perform_later(course_participation_detail.id) }
    end
  end

  def display_duration
    local_start_time = Timezone[driving_school.time_zone].utc_to_local(start_time)
    local_end_time = local_start_time + slots.count * 30.minutes

    "#{local_start_time.to_date} #{local_start_time.to_s(:time)} - #{local_end_time.to_s(:time)}"
  end

  private

  def decrement_available_hours_credit
    self.course_participation_detail.available_slot_credits -= slots.count
    self.course_participation_detail.save!
    self.course_participation_detail.refresh_slot_counts!
  end

  def schedule_job_for_refreshing_counts_after_lesson_take_place
    Courses::RefreshSlotCountsJob
      .set(wait_until: start_time + 1.second)
      .perform_later(course_participation_detail.id)
  end

  def start_time_in_future?
    start_time > Time.now
  end

  def broadcast_changed_driving_lesson
    BroadcastChangedDrivingLessonJob.perform_later(id)
  end
end
