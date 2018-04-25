class BroadcastActivityJob < ApplicationJob
  queue_as :default

  def perform(id)
    activity = Activity.find(id)
    return unless activity.driving_school.active?

    activity.notifiable_users = notifiable_users(activity)
    activity.related_users = related_users(activity)
    # Activities::SendPushNotificationService.new(activity).call
  end

  private

  def notifiable_users(activity)
    (notifiable_driving_school_employees(activity).to_a.map(&:employee) +
      activity_related_users(activity))
      .uniq(&:id).map { |u| u.becomes(User) }
  end

  def related_users(activity)
    activity_related_users(activity).uniq(&:id).map { |u| u.becomes(User) }
  end

  # Users related to given activity
  def activity_related_users(activity)
    case activity.activity_type
      when 'driving_course_changed'
        [activity.target.student_driving_school.student, activity.user]
      when 'schedule_changed'
        [activity.target.employee_driving_school.employee, activity.user]
      when 'driving_lesson_canceled', 'driving_lesson_scheduled'
        [activity.target.employee, activity.target.student, activity.user]
      when 'student_invitation_sent', 'student_invitation_withdrawn', 'student_invitation_accepted',
           'employee_invitation_sent', 'employee_invitation_withdrawn', 'employee_invitation_accepted'
        [activity.user]
      else
        []
    end
  end

  # Employees from driving school who should be notified
  def notifiable_driving_school_employees(activity)
    driving_school = activity.driving_school
    case activity.activity_type
      when 'student_invitation_sent', 'student_invitation_withdrawn',
           'student_invitation_accepted', 'student_invitation_rejected'
        driving_school.employee_driving_schools
          .joins(:employee, :employee_privileges)
          .where(status: :active)
          .where('"employee_privileges"."can_manage_students" IS TRUE OR "employee_privileges"."is_owner" IS TRUE')
      when 'employee_invitation_sent', 'employee_invitation_withdrawn',
           'employee_invitation_accepted', 'employee_invitation_rejected'
        driving_school.employee_driving_schools
          .joins(:employee, :employee_privileges)
          .where(status: :active)
          .where('"employee_privileges"."can_manage_employees" IS TRUE OR "employee_privileges"."is_owner" IS TRUE')
      when 'driving_course_changed', 'schedule_changed',
           'driving_lesson_canceled', 'driving_lesson_scheduled'
        driving_school.employee_driving_schools
          .joins(:employee, :employee_privileges)
          .where(status: :active)
          .where('"employee_privileges"."can_modify_schedules" IS TRUE OR "employee_privileges"."is_owner" IS TRUE')
      else
        []
    end
  end
end
