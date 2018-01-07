json.partial! 'driving_school', driving_school: @driving_school

if @current_user.employee?
  json.employee_driving_school_status @employee_driving_school.status
  json.privilege_set do
    json.partial! 'api/v1/employee_privilege_sets/employee_privilege_set',
                  employee_privilege_set: @employee_driving_school.employee_privilege_set
  end
elsif @current_user.student?
  json.student_driving_school_status @student_driving_school.status
end
