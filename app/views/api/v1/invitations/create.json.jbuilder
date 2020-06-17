if @user_driving_school_relation.is_a? EmployeeDrivingSchool
  json.partial! 'api/v1/employees/employee', locals: {
    employee: @user_driving_school_relation.employee,
    invitation: @user_driving_school_relation.invitation,
    employee_driving_school: @user_driving_school_relation,
    item: @user_driving_school_relation.employee || @user_driving_school_relation.invitation,
  }
  json.privileges do
    json.partial! 'api/v1/employee_privileges/employee_privileges',
                  employee_privileges: @user_driving_school_relation.employee_privileges
  end
elsif @user_driving_school_relation.is_a? StudentDrivingSchool
  json.partial! 'api/v1/students/student', locals: {
    student: @user_driving_school_relation.student,
    invitation: @user_driving_school_relation.invitation,
    item: @user_driving_school_relation.student || @user_driving_school_relation.invitation,
    student_driving_school: @user_driving_school_relation
  }
end
