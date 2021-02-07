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

json.pagination do
  json.is_more !@employee_driving_schools.last_page? && !@employee_driving_schools.out_of_range?
end

