json.extract! driving_lesson, :id, :start_time, :status

json.course do
  json.partial! 'api/v1/courses/course', course: driving_lesson.course_participation_detail.course
end

json.employee do
  json.partial! 'api/v1/users/user_min', user: driving_lesson.employee
end

json.student do
  json.partial! 'api/v1/users/user_min', user: driving_lesson.student
end

json.slots driving_lesson.slots do |slot|
  json.partial! 'api/v1/slots/slot', slot: slot
end
