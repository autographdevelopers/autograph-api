json.student do
  json.partial! 'api/v1/students/student', locals: {
    student: @student_school.student,
    invitation: @student_school.invitation,
    item: @student_school.student || @student_school.invitation,
    student_driving_school: @student_school
  }
end

json.driving_courses do
  json.array! @student_school.driving_courses,
              partial: 'api/v1/driving_courses/driving_course',
              as: :driving_course
end
