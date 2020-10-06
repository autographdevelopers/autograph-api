IOS_COLORS = [
  {
    palette_name: 'ios',
    hex_val: '5fc9f8',
    application: :general,
  },
  {
    palette_name: 'ios',
    hex_val: 'fecb2e',
    application: :general,
  },
  {
    palette_name: 'ios',
    hex_val: 'fc3158',
    application: :general,
  },
  {
    palette_name: 'ios',
    hex_val: '147EFB',
    application: :general,
  },
  {
    palette_name: 'ios',
    hex_val: '53D769',
    application: :general,
  },
  {
    palette_name: 'ios',
    hex_val: 'fc3d39',
    application: :general,
  }
].freeze

IOS_COLORS.each do |color|
  Color.create!(color)
end

%w[A B C D].each do |letter|
  label = Label.create!(name: "[Prebuilt] Course for category #{letter}", purpose: :course_category, prebuilt: true)
end

employee = FactoryBot.create(:employee, email: 'employee@gmail.com', password: 'Password1!')
student = FactoryBot.create(:student, email: 'student@gmail.com', password: 'Password1!')
owner = FactoryBot.create(:employee, email: 'owner@gmail.com', password: 'Password1!')

DrivingSchool.statuses.keys.each do |status|
  EmployeeDrivingSchool.statuses.keys.each do |e_status|
    eds = FactoryBot.create(:employee_driving_school,
                      driving_school: FactoryBot.create(:driving_school, :with_schedule_settings, status: status),
                      employee: employee,
                      status: e_status)
    eds.employee_privileges.update(can_manage_employees: true, can_manage_students: true, can_modify_schedules: true, is_driving: true)
    FactoryBot.create(:employee_driving_school,
                      driving_school: FactoryBot.create(:driving_school, :with_schedule_settings,  status: status),
                      employee: owner,
                      status: e_status,
                      is_owner: true)
  end

  StudentDrivingSchool.statuses.keys.each do |s_status|
    FactoryBot.create(:student_driving_school,
                      driving_school: FactoryBot.create(:driving_school, :with_schedule_settings, status: status),
                      student: student,
                      status: s_status)
  end
end

5.times do
  driving_school = FactoryBot.create(:driving_school, :with_schedule_settings, status: :active)
  %w[A B C D].each do |letter|
    label = Label.create!(name: "Course for category #{letter}", purpose: :course_category)
    LabelableLabel.create!(labelable: driving_school, label: label)
  end
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
    sds = FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :active)

    FactoryBot.create(:employee_driving_school, driving_school: driving_school, status: :archived)
    FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :archived)

    FactoryBot.create(:employee_driving_school, driving_school: driving_school, status: :pending)
    FactoryBot.create(:student_driving_school, driving_school: driving_school, status: :pending)

    if i == 3
      3.times do |i|
        FactoryBot.create(:driving_lesson,
                          driving_school: driving_school,
                          employee: eds.employee,
                          student: sds.student,
                          start_time: i.days.from_now)
      end
    end
  end
end

