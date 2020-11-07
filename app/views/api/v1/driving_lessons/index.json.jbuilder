json.results do
  json.array! @driving_lessons do |driving_lesson|
    json.partial! 'driving_lesson', driving_lesson: driving_lesson

    json.course do
      json.partial! 'api/v1/courses/course', course: driving_lesson.course_participation_detail.course
    end

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
  end
end

json.pagination do
  json.is_more !@driving_lessons.last_page? && !@driving_lessons.out_of_range?
end
