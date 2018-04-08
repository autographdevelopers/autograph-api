class Activities::SendPushNotificationService
  attr_reader :activity

  NOTIFICATIONS_MAP = {
    student_invitation_sent: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    student_invitation_withdrawn: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    student_invitation_accepted: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    student_invitation_rejected: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    employee_invitation_sent: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    employee_invitation_withdrawn: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    employee_invitation_accepted: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    employee_invitation_rejected: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    driving_course_changed: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    schedule_changed: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    driving_lesson_canceled: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    },
    driving_lesson_scheduled: {
      subject: 'Test',
      subtitle: 'Test',
      headings: 'Test'
    }
  }.freeze

  def initialize(activity)
    @activity = activity
  end

  def call

  end

  private


end
