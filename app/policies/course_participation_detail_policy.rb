class CourseParticipationDetailPolicy < ApplicationPolicy
  def index?
    p "************"
    p "************"
    p "************"
    p "************"
    p "************"

    # TODO ADD OWNER!
    # p record.student_id
    # p user.id
    # (record.is_a?(Course) && user.employee?) || (record.is_a?(StudentDrivingSchool) && record.student_id == user.id)
    true
  end
end
