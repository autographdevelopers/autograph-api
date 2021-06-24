module Slots
  module Helpers
    extend ActiveSupport::Concern

    included do
      def substitute_current_schedule_with_new_schedule
        return unless templates_should_switch?

        new_template = schedule.new_template

        schedule.update!(
          new_template_binding_from: nil,
          current_template: new_template,
          new_template: {
            monday: [],
            tuesday: [],
            wednesday: [],
            thursday: [],
            friday: [],
            saturday: [],
            sunday: []
          }
        )
      end

      def templates_should_switch?
        schedule.new_template_binding_from == today
      end

      def create_slots(date_times)
        Slot.bulk_insert do |worker|
          date_times.each do |date_time|
            worker.add(
              employee_driving_school_id: employee_driving_school.id,
              start_time: date_time
            )
          end
        end
      end

      def parse_to_date_time(date, time)
        # what if date is actually datetime? how does this merges
        p %(driving_school_time_zone.local_to_utc("#{date} #{time}".to_datetime))
        p driving_school_time_zone.local_to_utc("#{date} #{time}".to_datetime)

        p " czcasddas.to_datetime "
        p "#{date} #{time}".to_datetime

        driving_school_time_zone.local_to_utc("#{date} #{time}".to_datetime)
      end

      def holidays_booking_disabled?
        !driving_school.schedule_settings.holidays_enrollment_enabled?
      end

      def holiday?(date)
        Holidays.on(date, driving_school.country_code.to_sym).any?
      end

      def today
        driving_school_time_zone.utc_to_local(Time.now).to_date
      end

      def last_day_of_possible_booking
        driving_school_time_zone.utc_to_local(
          driving_school.schedule_settings
                        .booking_advance_period_in_weeks
                        .to_i.weeks.from_now
        ).to_date
      end

      def driving_school_time_zone
        Timezone[driving_school.time_zone]
      end
    end
  end
end