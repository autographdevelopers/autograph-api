json.array! @driving_schools do |driving_school|
  json.partial! 'driving_school', driving_school: driving_school[:basic_information]

  if @current_user.employee?
    json.employee_driving_school_status driving_school[:employee_driving_school_status]
    json.privilege_set do
      json.partial! 'api/v1/employee_privilege_sets/employee_privilege_set',
                    employee_privilege_set: driving_school[:employee_privilege_set]
    end
  elsif @current_user.student?
    json.student_driving_school_status driving_school[:student_driving_school_status]
  end
end