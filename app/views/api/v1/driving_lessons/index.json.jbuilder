json.array! @driving_lessons do |driving_lesson|
  json.partial! 'driving_lesson', driving_lesson: driving_lesson

  json.employee do
    json.id driving_lesson.employee_driving_school.employee.id
    json.name driving_lesson.employee_driving_school.employee.name
    json.surname driving_lesson.employee_driving_school.employee.surname
  end

  json.student do
    json.id driving_lesson.student_driving_school.student.id
    json.name driving_lesson.student_driving_school.student.name
    json.surname driving_lesson.student_driving_school.student.surname
  end

  json.slots driving_lesson.slots do |slot|
    json.partial! 'api/v1/slots/slot', slot: slot
  end
end
