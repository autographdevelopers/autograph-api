json.array! @employee_driving_schools.each do |eds|
  json.partial! 'employee', locals: { employee: eds.employee || eds.invitation, employee_driving_school: eds }
end
