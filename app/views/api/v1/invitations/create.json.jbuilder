if @user_driving_school_relation.is_a? EmployeeDrivingSchool
  json.partial! 'api/v1/employees/employee', locals: {
    employee: @user_driving_school_relation.employee,
    employee_driving_school: @user_driving_school_relation,
  }
  json.privileges do
    json.partial! 'api/v1/employee_privileges/employee_privileges',
                  employee_privileges: @user_driving_school_relation.employee_privileges
  end
elsif @user_driving_school_relation.is_a? StudentDrivingSchool
  json.partial! 'api/v1/students/student', locals: {
    student: @user_driving_school_relation.student,
    student_driving_school: @user_driving_school_relation
  }
end
