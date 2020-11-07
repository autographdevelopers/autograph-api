
json.extract! course_participation_detail, :id, :available_hours, :booked_hours, :used_hours, :discarded_at, :course_id
json.student_id { course_participation_detail.student_driving_school.student_id }

json.student do
  json.partial! 'api/v1/students/student', locals: {
    student: course_participation_detail.student_driving_school.student,
    invitation: nil,
    item: course_participation_detail.student_driving_school.student,
    student_driving_school: course_participation_detail.student_driving_school
  }
end

json.course { json.partial! 'api/v1/courses/course', locals: { course: course_participation_detail.course } }
