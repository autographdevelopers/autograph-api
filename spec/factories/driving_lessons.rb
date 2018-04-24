FactoryBot.define do
  factory :driving_lesson do
    start_time 7.days.from_now
    student
    employee
    driving_school

    transient do
      slots_count 0
    end

    after(:build) do |driving_lesson|
      EmployeeDrivingSchool.find_by(employee: driving_lesson.employee, driving_school: driving_lesson.driving_school) ||
        create(:employee_driving_school, employee: driving_lesson.employee, driving_school: driving_lesson.driving_school)
      StudentDrivingSchool.find_by(student: driving_lesson.student, driving_school: driving_lesson.driving_school) ||
        create(:student_driving_school, student: driving_lesson.student, driving_school: driving_lesson.driving_school)
    end

    after(:create) do |driving_lesson, evaluator|
      start_times = Array.new(evaluator.slots_count) { |i| driving_lesson.start_time + i * 30.minutes }

      start_times.each do |start_time|
        employee_driving_school = create(:employee_driving_school,
                                         employee: driving_lesson.employee,
                                         driving_school: driving_lesson.driving_school)

        create(:slot,
               employee_driving_school: employee_driving_school,
               driving_lesson: driving_lesson,
               start_time: start_time)
      end
    end
  end
end
