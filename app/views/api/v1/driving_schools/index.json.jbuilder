json.array! @user_driving_schools do |user_driving_school|
  json.partial! 'driving_school', driving_school: user_driving_school.driving_school
  json.relation_status user_driving_school.status

  if @current_user.employee?
    json.privileges do
      json.partial! 'api/v1/employee_privileges/employee_privileges',
                    employee_privileges: user_driving_school.employee_privileges
    end
  end
end
