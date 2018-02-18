employee = FactoryBot.create(:employee, email: 'employee@gmail.com', password: 'password')
student = FactoryBot.create(:student, email: 'student@gmail.com', password: 'password')
owner = FactoryBot.create(:employee, email: 'owner@gmail.com', password: 'password')

DrivingSchool.statuses.keys.each do |status|
  EmployeeDrivingSchool.statuses.keys.each do |e_status|
    FactoryBot.create(:employee_driving_school, driving_school: FactoryBot.create(:driving_school, status: status), employee: employee, status: e_status)
  end

  EmployeeDrivingSchool.statuses.keys.each do |o_status|
    FactoryBot.create(:employee_driving_school, driving_school: FactoryBot.create(:driving_school, status: status), employee: owner, status: o_status, is_owner: true)
  end

  StudentDrivingSchool.statuses.keys.each do |s_status|
    FactoryBot.create(:student_driving_school, driving_school: FactoryBot.create(:driving_school, status: status), student: student, status: s_status)
  end
end

DrivingSchool.where(status: :active).each do |driving_school|
  5.times do |i|
    eds = FactoryBot.create(:employee_driving_school, driving_school: driving_school, status: :active)
    eds.employee_privilege_set.update(
      can_manage_employees: i == 0,
      can_manage_students: i == 1,
      can_modify_schedules: i == 2,
      is_driving: i == 3,
      is_owner: i == 4
    )

    FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :active)
  end

  FactoryBot.create(:employee_driving_school, driving_school: driving_school, status: :archived)
  FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :archived)

  FactoryBot.create(:employee_driving_school, driving_school: driving_school, status: :pending)
  FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :pending)
end
