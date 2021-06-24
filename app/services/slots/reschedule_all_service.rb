# Slots::RescheduleAllService
# Basing on passed schedule it deletes all future slots,
# which are not booked, and creates new one.
module Slots
  class RescheduleAllService
    attr_reader :employee_driving_school, :schedule, :driving_school,
                :new_template_binding_from

    def initialize(schedule)
      @employee_driving_school = schedule.employee_driving_school
      @schedule = schedule
      @driving_school = @employee_driving_school.driving_school
      # date type column not time nor timezone
      # new_template_binding_from - does not consider timezone - probably a bug
      @new_template_binding_from = schedule.new_template_binding_from
    end

    def call
      Slot.transaction do
        delete_all_future_available_slots
        create_slots(slot_date_times_to_be_created - booked_slots_date_times)
      end
    end

    private

    include Helpers

    def slot_date_times_to_be_created
      dates_ranges = get_dates_ranges
      date_times_to_create = []

      date_times_to_create << extract_date_times(dates_ranges[0], schedule.current_template)
      date_times_to_create << extract_date_times(dates_ranges[1], schedule.new_template)

      #ensures only date-times in future are processed
      date_times_to_create.flatten.select { |date_time| date_time.utc > DateTime.now.utc }.to_a
    end

    def get_dates_ranges
      dates_ranges = []

      if (today..last_day_of_possible_booking).cover?(new_template_binding_from) # there will be a change in schedule
        dates_ranges << (today..new_template_binding_from.yesterday)
        dates_ranges << (new_template_binding_from..last_day_of_possible_booking)
      else
        dates_ranges << (today..last_day_of_possible_booking)
        dates_ranges << []
      end

      if holidays_booking_disabled?
        dates_ranges.map! { |dates| filter_out_holidays(dates) }
      end

      p "dates_ranges"
      p dates_ranges

      dates_ranges
    end

    def extract_date_times(dates_range, schedule_template)
      date_times = []

      ScheduleConstants::WEEKDAYS.each do |weekday, weekday_index|
        slot_start_times_ids = schedule_template[weekday]
        next unless slot_start_times_ids.present?

        dates = dates_range.to_a.select { |day| day.wday == weekday_index } # get all days which are mondays, then - in next iteration, take tuesdays etc..
        times = slot_start_times_ids.map { |id| ScheduleConstants::SLOT_START_TIMES[id] } # get all start times for particular weekday

        # this algorithm scans calendar vertically

        dates.each do |date|
          times.each do |time|
            p "<>date<>"
            p date
            p "<>time<>"
            p time
            date_times << parse_to_date_time(date, time)
          end
        end
      end

      date_times
    end

    def filter_out_holidays(dates)
      dates.reject { |date| holiday?(date) }
    end

    def booked_slots_date_times
      employee_driving_school.slots.future.booked.pluck(:start_time)
    end

    def delete_all_future_available_slots
      employee_driving_school.slots.future.available.destroy_all
    end
  end
end