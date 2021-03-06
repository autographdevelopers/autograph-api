json.results do
  json.array! @employee_driving_schools.each do |employee_driving_school|
    json.partial! 'employee', locals: {
      employee: employee_driving_school.employee,
      employee_driving_school: employee_driving_school
    }

    if current_user.employee?
      json.privileges do
        json.partial! 'api/v1/employee_privileges/employee_privileges',
          employee_privileges: employee_driving_school.employee_privileges
      end
    end
  end
end

json.partial! 'api/v1/helper/pagination', locals: { collection: @employee_driving_schools }
