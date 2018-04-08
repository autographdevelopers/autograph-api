class Activity < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :driving_school
  belongs_to :target, polymorphic: true
  belongs_to :user

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
    driving_course_changed: 8
  }

  # == Callbacks ==============================================================
  after_create :notify_about_activity

  def notify_about_activity
    # Schedule Job
  end
end
