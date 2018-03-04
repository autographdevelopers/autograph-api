class ScheduleSlotsService
  attr_reader :employee_driving_school, :schedule, :driving_school

  def initialize(schedule)
    @employee_driving_school = schedule.employee_driving_school
    @schedule = schedule
    @driving_school = @employee_driving_school.driving_school
  end

  def call
    Slot.transaction do
      delete_all_future_available_slots
      create_slots(slot_date_times_to_be_created - booked_slots_date_times)
    end
  end

  private

  def create_slots(date_times)
    Slot.bulk_insert do |worker|
      date_times.each do |date_time|
        worker.add(employee_driving_school_id: employee_driving_school.id, start_time: date_time)
      end
    end
  end

  def get_dates_ranges
    dates_ranges = []

    if (current_date_for_driving_school_timezone..schedule_repetition_end_date_for_driving_school_timezone).cover?(schedule.new_template_binding_from)
      dates_ranges << (current_date_for_driving_school_timezone..(schedule.new_template_binding_from.yesterday))
      dates_ranges << (schedule.new_template_binding_from..schedule_repetition_end_date_for_driving_school_timezone)
    else
      dates_ranges << (current_date_for_driving_school_timezone..schedule_repetition_end_date_for_driving_school_timezone)
      dates_ranges << []
    end

    unless driving_school.schedule_settings_set.holidays_enrollment_enabled?
      dates_ranges.map! do |dates_range|
        dates_range.select { |date| Holidays.on(date, :pl).empty? }
      end
    end

    dates_ranges
  end


  def slot_date_times_to_be_created
    dates_ranges = get_dates_ranges
    date_times_to_create = []

    date_times_to_create << extract_date_times(dates_ranges[0], schedule.current_template)
    date_times_to_create << extract_date_times(dates_ranges[1], schedule.new_template)

    date_times_to_create.flatten.select{ |date_time| date_time.utc > DateTime.now.utc }.to_a
  end

  def extract_date_times(dates_range, schedule_template)
    date_times = []

    ScheduleConstants::WEEKDAYS.each do |weekday, weekday_index|
      slot_start_times_ids = schedule_template[weekday]
      next unless slot_start_times_ids.present?

      dates = dates_range.to_a.select { |day| day.wday == weekday_index }
      times = slot_start_times_ids.map { |id| ScheduleConstants::SLOT_START_TIMES[id] }

      dates.each do |date|
        times.each do |time|
          date_times << parse_to_date_time(date, time)
        end
      end
    end

    date_times
  end

  def booked_slots_date_times
    employee_driving_school.slots.future.booked.pluck(:start_time)
  end

  def delete_all_future_available_slots
    employee_driving_school.slots.future.available.destroy_all
  end

  def parse_to_date_time(date, time)
    Timezone[driving_school.time_zone].local_to_utc("#{date.to_s} #{time}".to_datetime)
  end

  def current_date_for_driving_school_timezone
    Timezone[driving_school.time_zone].utc_to_local(Time.now).to_date
  end

  def schedule_repetition_end_date_for_driving_school_timezone
    Timezone[driving_school.time_zone].utc_to_local(schedule.repetition_period_in_weeks.to_i.weeks.from_now).to_date
  end
end
