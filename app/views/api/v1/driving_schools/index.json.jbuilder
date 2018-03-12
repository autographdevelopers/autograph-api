json.array! @user_driving_schools do |user_driving_school|
  json.partial! 'driving_school', driving_school: user_driving_school.driving_school
  json.relation_status user_driving_school.status

  if @current_user.employee?
    json.privilege_set do
      json.partial! 'api/v1/employee_privilege_sets/employee_privilege_set',
                    employee_privilege_set: user_driving_school.employee_privilege_set
    end
  end
end
