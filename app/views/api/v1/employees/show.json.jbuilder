json.partial! 'employee', locals: {
  employee: @employee_driving_school.employee,
  employee_driving_school: @employee_driving_school
}

json.privileges do
  json.partial! 'api/v1/employee_privileges/employee_privileges',
                employee_privileges: @employee_driving_school.employee_privileges
end
