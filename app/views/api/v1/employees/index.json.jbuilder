json.array! @employee_driving_schools.each do |employee_driving_school|
  json.partial! 'employee', locals: {
    employee: employee_driving_school.employee || employee_driving_school.invitation,
    employee_driving_school: employee_driving_school
  }
end
