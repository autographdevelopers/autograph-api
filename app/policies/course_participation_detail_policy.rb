class CourseParticipationDetailPolicy < ApplicationPolicy
  def index?
    (record.is_a?(Course) && user.employee?) || (record.is_a?(StudentDrivingSchool) && record.student_id == user.id)
  end
end
