class Activities::SendPushNotificationService
  attr_reader :activity

  NOTIFICATIONS_MAP = {
    student_invitation_sent: {
      headings: 'student_invitation_sent',
      contents: 'student_invitation_sent'
    },
    student_invitation_withdrawn: {
      headings: 'student_invitation_withdrawn',
      contents: 'student_invitation_withdrawn'
    },
    student_invitation_accepted: {
      headings: 'student_invitation_accepted',
      contents: 'student_invitation_accepted'
    },
    student_invitation_rejected: {
      headings: 'student_invitation_rejected',
      contents: 'student_invitation_rejected'
    },
    employee_invitation_sent: {
      headings: 'employee_invitation_sent',
      contents: 'employee_invitation_sent'
    },
    employee_invitation_withdrawn: {
      headings: 'employee_invitation_withdrawn',
      contents: 'employee_invitation_withdrawn'
    },
    employee_invitation_accepted: {
      headings: 'employee_invitation_accepted',
      contents: 'employee_invitation_accepted'
    },
    employee_invitation_rejected: {
      headings: 'employee_invitation_rejected',
      contents: 'employee_invitation_rejected'
    },
    driving_course_changed: {
      headings: 'driving_course_changed',
      contents: 'driving_course_changed'
    },
    schedule_changed: {
      headings: 'schedule_changed',
      contents: 'schedule_changed'
    },
    driving_lesson_canceled: {
      headings: 'driving_lesson_canceled',
      contents: 'driving_lesson_canceled'
    },
    driving_lesson_scheduled: {
      headings: 'driving_lesson_scheduled',
      contents: 'driving_lesson_scheduled'
    }
  }.freeze

  def initialize(activity)
    @activity = activity
  end

  def call
    details = NOTIFICATIONS_MAP[activity.activity_type.to_sym]

    OneSignal::Notification.create(
      params: {
        app_id: Rails.application.secrets.one_signal_app_id,
        include_player_ids: player_ids,
        headings: { 'pl' => details[:headings] },
        contents: { 'pl' => details[:contents] }
      }
    )
  end

  private

  def player_ids
    activity.notifiable_users.to_a.delete_if { |u| u.id == activity.user.id }
                             .pluck(:player_id)
                             .compact
  end
end
