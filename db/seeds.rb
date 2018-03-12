employee = FactoryBot.create(:employee, email: 'employee@gmail.com', password: 'password')
student = FactoryBot.create(:student, email: 'student@gmail.com', password: 'password')
owner = FactoryBot.create(:employee, email: 'owner@gmail.com', password: 'password')

DrivingSchool.statuses.keys.each do |status|
  EmployeeDrivingSchool.statuses.keys.each do |e_status|
    eds = FactoryBot.create(:employee_driving_school,
                      driving_school: FactoryBot.create(:driving_school, :with_schedule_settings_set, :with_schedule_boundaries, status: status),
                      employee: employee,
                      status: e_status)
    eds.employee_privileges.update(can_manage_employees: true, can_manage_students: true, can_modify_schedules: true, is_driving: true)
    FactoryBot.create(:employee_driving_school,
                      driving_school: FactoryBot.create(:driving_school, :with_schedule_settings_set, :with_schedule_boundaries, status: status),
                      employee: owner,
                      status: e_status,
                      is_owner: true)
  end

  StudentDrivingSchool.statuses.keys.each do |s_status|
    FactoryBot.create(:student_driving_school,
                      driving_school: FactoryBot.create(:driving_school, :with_schedule_settings_set, :with_schedule_boundaries, status: status),
                      student: student,
                      status: s_status)
  end
end

5.times do
  driving_school = FactoryBot.create(:driving_school, :with_schedule_settings_set, :with_schedule_boundaries, status: :active)
  FactoryBot.create(:employee_driving_school, driving_school: driving_school, employee: employee, status: :pending)
  FactoryBot.create(:employee_driving_school, driving_school: driving_school, employee: owner, status: :pending)
  FactoryBot.create(:student_driving_school, driving_school: driving_school, student: student, status: :pending)
end

DrivingSchool.active.each do |driving_school|
  5.times do |i|
    eds = FactoryBot.create(:employee_driving_school, driving_school: driving_school, status: :active)
    eds.employee_privileges.update(
      can_manage_employees: i == 0,
      can_manage_students: i == 1,
      can_modify_schedules: i == 2,
      is_driving: i == 3,
      is_owner: i == 4
    )
    FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :active)

    FactoryBot.create(:employee_driving_school, driving_school: driving_school, status: :archived)
    FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :archived)

    FactoryBot.create(:employee_driving_school, driving_school: driving_school, status: :pending)
    FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :pending)
  end
end

