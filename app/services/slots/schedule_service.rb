# Slots::ScheduleService
# Basing on passed schedule and date it schedules slots for given date
module Slots
  class ScheduleService
    attr_reader :employee_driving_school,
                :schedule,
                :driving_school,
                :date,
                :new_template_binding_from

    def initialize(schedule, date)
      @employee_driving_school = schedule.employee_driving_school
      @schedule = schedule
      @driving_school = @employee_driving_school.driving_school
      # new_template_binding_from - does not consider timezone - probably a bug
      @new_template_binding_from = schedule.new_template_binding_from
      @date = date
    end

    def call
      return if holidays_booking_disabled? && holiday?(date)

      create_slots(slot_date_times_to_be_created)
    end

    private

    include Helpers

    def slot_date_times_to_be_created
      if use_new_template?
        extract_date_times(schedule.new_template)
      else
        extract_date_times(schedule.current_template)
      end
    end

    def extract_date_times(schedule_template)
      slot_start_times_ids = schedule_template[weekday_name]
      times = slot_start_times_ids.map { |id| ScheduleConstants::SLOT_START_TIMES[id] }

      times.map { |time| parse_to_date_time(date, time) }
    end

    def use_new_template?
      new_template_binding_from.present? && date >= new_template_binding_from
    end

    def weekday_name
      date.strftime("%A").downcase
    end
  end
end
