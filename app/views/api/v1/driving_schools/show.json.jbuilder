json.partial! 'api/v1/driving_schools/driving_school', driving_school: user_driving_school.driving_school
json.relation_status user_driving_school.status

if @current_user.employee?
  json.privilege_set do
    json.partial! 'api/v1/employee_privileges/employee_privileges',
                  employee_privileges: user_driving_school.employee_privileges
  end
end
