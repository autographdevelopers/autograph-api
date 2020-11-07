json.results do
  json.array! @student_driving_schools.each do |student_driving_schools|
    json.partial! 'student', locals: {
      student: student_driving_schools.student,
      invitation: student_driving_schools.invitation,
      item: student_driving_schools.student || student_driving_schools.invitation,
      student_driving_school: student_driving_schools
    }
  end
end

json.pagination do
  json.is_more (!@student_driving_schools.last_page? && !@student_driving_schools.out_of_range?)
end
