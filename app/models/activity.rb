class Activity < ApplicationRecord
  # == Relations ==============================================================
  belongs_to :driving_school
  belongs_to :target, polymorphic: true
  belongs_to :user
  has_many :notifiable_user_activities
  has_many :notifiable_users,
           through: :notifiable_user_activities,
           source: :user

  has_many :related_user_activities
  has_many :related_users,
           through: :related_user_activities,
           source: :user

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

  # == Validations ============================================================
  validates :message, :activity_type, presence: true

  # == Scopes =================================================================
  scope :related_to_user, ->(value) do
    includes(:related_user_activities).where(related_user_activities: { user_id: value })
  end

  # == Callbacks ==============================================================
  before_validation :determine_message, on: :create
  after_create :notify_about_activity

  private

  def notify_about_activity
    BroadcastActivityJob.perform_later(id)
  end

  def determine_message
    self.message = I18n.t(
      "activities.messages.#{activity_type}",
      { user_full_name: user.full_name }.merge(translation_params)
    )
  end

  def translation_params
    case activity_type
      when 'student_invitation_sent', 'student_invitation_withdrawn'
        {
          student_full_name: target.student_full_name,
          student_email: target.student_email
        }
      when 'employee_invitation_sent', 'employee_invitation_withdrawn'
        {
          employee_full_name: target.employee_full_name,
          employee_email: target.employee_email
        }
      when 'driving_course_changed'
        {
          student_full_name: target.student_driving_school.student.full_name,
          available_hours: target.available_hours
        }
      when 'schedule_changed'
        {
          employee_full_name: target.employee_driving_school.employee.full_name
        }
      when 'driving_lesson_canceled', 'driving_lesson_scheduled'
        {
          duration: target.display_duration,
          student_full_name: target.student.full_name,
          employee_full_name: target.employee.full_name
        }
      else
        {}
    end
  end
end
