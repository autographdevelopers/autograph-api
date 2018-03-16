class ScheduleSlotsJob < ApplicationJob
  queue_as :default

  def perform(time_zone)
    last_day_of_possible_booking = last_day_of_possible_booking

    employee_driving_schools = EmployeeDrivingSchool.active_with_active_driving_school
                                                    .where(driving_schools: { time_zone: time_zone })
                                                    .where(employee_privileges: { is_driving: true })
                                                    .includes(:employee_privileges, :schedule)

    employee_driving_schools.each do |employee_driving_school|
      schedule = employee_driving_school.schedule

      next if last_update_date_today?(employee_driving_school.schedule)

      Slots::ScheduleService.new(
        schedule, last_day_of_possible_booking(schedule, time_zone)
      ).call
    end
  end

  def last_update_date_today?(schedule)
    schedule.updated_at.to_date == Date.today
  end

  def last_day_of_possible_booking(schedule, time_zone)
    Timezone[time_zone].utc_to_local(
      schedule.repetition_period_in_weeks.to_i.weeks.from_now
    ).to_date
  end
end
