json.array! @student_driving_schools.each do |sds|
  json.partial! 'student', locals: { student: sds.student || sds.invitation, student_driving_school: sds }
end
