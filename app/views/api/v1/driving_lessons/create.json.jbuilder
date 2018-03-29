json.partial! 'api/v1/driving_lessons/driving_lesson', driving_lesson: driving_lesson

json.employee do
  json.id driving_lesson.employee.id
  json.name driving_lesson.employee.name
  json.surname driving_lesson.employee.surname
end

json.student do
  json.id driving_lesson.student.id
  json.name driving_lesson.student.name
  json.surname driving_lesson.student.surname
end

json.slots driving_lesson.slots do |slot|
  json.partial! 'api/v1/slots/slot', slot: slot
end
