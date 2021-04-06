json.partial! 'api/v1/helper/pagination', locals: { collection: @student_driving_schools }

json.results do
  json.array! @student_driving_schools.each do |student_driving_schools|
    json.partial! 'student', locals: {
      student: student_driving_schools.student,
      student_driving_school: student_driving_schools
    }
  end
end
