json.array! @student_driving_schools.each do |student_driving_schools|
  json.partial! 'student', locals: {
    student: student_driving_schools.student || student_driving_schools.invitation,
    student_driving_school: student_driving_schools
  }
end
