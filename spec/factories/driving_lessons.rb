FactoryBot.define do
  factory :driving_lesson do
    start_time 7.days.from_now
    student
    employee
    driving_school

    transient do
      slots_count 0
    end

    after(:create) do |driving_lesson, evaluator|
      if evaluator.slots_count > 0
        start_times = evaluator.slots_count.times.map do |i|
                        driving_lesson.start_time + i * 30.minutes
                      end

        start_times.each do |start_time|
          create(:slot,
                 employee_driving_school: create(:employee_driving_school,
                   employee: driving_lesson.employee,
                   driving_school: driving_lesson.driving_school
                 ),
                 driving_lesson: driving_lesson,
                 start_time: start_time)
        end
      end
    end
  end
end
