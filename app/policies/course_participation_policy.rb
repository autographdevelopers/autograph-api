class CourseParticipationPolicy < ApplicationPolicy
  allow :show?, if: -> do
    user.employee? || record.student_driving_school.student_id == user.id
  end
end
