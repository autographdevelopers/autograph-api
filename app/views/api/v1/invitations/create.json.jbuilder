if @user_driving_school_relation.is_a? EmployeeDrivingSchool
  json.partial! 'api/v1/employees/employee', locals: {
    employee: @user_driving_school_relation.employee || @user_driving_school_relation.invitation,
    employee_driving_school: @user_driving_school_relation
  }
elsif  @user_driving_school_relation.is_a? StudentDrivingSchool
  json.partial! 'api/v1/students/student', locals: {
    student: @user_driving_school_relation.student || @user_driving_school_relation.invitation,
    student_driving_school: @user_driving_school_relation
  }
end
