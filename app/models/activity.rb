class Activity < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :driving_school
  belongs_to :target, polymorphic: true
  belongs_to :user
  has_many :user_activities
  has_many :notifiable_users, through: :user_activities, source: :user

  # == Enumerators ============================================================
  enum activity_type: {
    student_invitation_sent: 0,
    student_invitation_withdrawn: 1,
    student_invitation_accepted: 2,
    student_invitation_rejected: 3,
    employee_invitation_sent: 4,
    employee_invitation_withdrawn: 5,
    employee_invitation_accepted: 6,
    employee_invitation_rejected: 7,
    driving_course_changed: 8,
    schedule_changed: 9,
    driving_lesson_canceled: 10,
    driving_lesson_scheduled: 11
  }

  # == Callbacks ==============================================================
  after_create :notify_about_activity

  def notify_about_activity
    BroadcastActivityJob.perform_later(id)
  end
end
