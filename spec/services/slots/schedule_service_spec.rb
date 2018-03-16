describe Slots::ScheduleService do
  include ActiveSupport::Testing::TimeHelpers

  before(:all) { travel_to Time.new(2018, 3, 16, 0, 0, 0, '+02:00') }

  context '#call' do
    let(:date_times_range) do
      ->(start_date_time:, end_date_time:){
        return (start_date_time.to_datetime.to_i..end_date_time.to_datetime.to_i).step(30.minutes).map { |d| Time.at(d).utc }
      }
    end

    subject { Slots::ScheduleService.new(schedule, date) }
    let(:employee_driving_school) { schedule.employee_driving_school }

    context "when driving school has time zone set to 'Poland'" do
      before do
        employee_driving_school.driving_school.update(time_zone: 'Poland')
      end

      context 'when holidays_enrollment_enabled set to true' do
        before do
          employee_driving_school.driving_school
                                 .create_schedule_settings(
                                   holidays_enrollment_enabled: true
                                 )
        end

        # summer time +02:00
        context 'when schedule is set on 2018-04-02(monday) 00:30:00' do
          before { travel_to Time.new(2018, 4, 2, 0, 30, 0, '+02:00') }

          context 'new_template_binding_from is set to 2018-04-09' do
            let(:schedule) do
              create(:schedule,
                     repetition_period_in_weeks: 1,
                     new_template_binding_from: Date.new(2018, 4, 9),
                     current_template: {
                       monday: (16..31).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: (16..31).to_a,
                       thursday: (16..31).to_a,
                       friday: (16..31).to_a,
                       saturday: (16..19).to_a,
                       sunday: []
                     },
                     new_template: {
                       monday: [],
                       tuesday: (16..31).to_a,
                       wednesday: (16..31).to_a,
                       thursday: (16..31).to_a,
                       friday: (16..31).to_a,
                       saturday: [],
                       sunday: (32..47).to_a
                     })
            end

            context 'when date is set to 2018-04-04' do
              let(:date) { Date.new(2018, 4, 4) }

              before { subject.call }

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  date_times_range.call(start_date_time: '2018-04-04 08:00 +02:00', end_date_time: '2018-04-04 15:30 +02:00'),# Wednesday
                )
              end
            end

            context 'when date is set to 2018-04-09' do
              let(:date) { Date.new(2018, 4, 9) }

              before { subject.call }

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to be_empty
              end
            end

            context 'when date is set to 2018-04-15' do
              let(:date) { Date.new(2018, 4, 15) }

              before { subject.call }

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  date_times_range.call(start_date_time: '2018-04-15 16:00 +02:00', end_date_time: '2018-04-15 23:30 +02:00'),# Sunday
                )
              end
            end
          end
        end
      end

      context 'when holidays_enrollment_enabled set to false' do
        before do
          employee_driving_school.driving_school
            .create_schedule_settings(
              holidays_enrollment_enabled: false
            )
        end

        # winter time +01:00
        context 'when schedule is set on 2018-12-12(tuesday) 16:30:00' do
          before { travel_to Time.new(2018, 12, 12, 16, 30, 0, '+01:00') }

          context 'new_template_binding_from is set to nil' do
            let(:schedule) do
              create(:schedule,
                     repetition_period_in_weeks: 1,
                     new_template_binding_from: nil,
                     current_template: {
                       monday: (16..31).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: (16..31).to_a,
                       thursday: (16..31).to_a,
                       friday: (16..31).to_a,
                       saturday: (16..19).to_a,
                       sunday: []
                     })
            end

            context 'when date is set to 2018-04-04' do
              let(:date) { Date.new(2018, 12, 17) }

              before { subject.call }

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  date_times_range.call(start_date_time: '2018-12-17 08:00 +01:00', end_date_time: '2018-12-17 15:30 +01:00'),# Wednesday
                )
              end
            end

            context 'when date is set to 2018-12-25' do
              let(:date) { Date.new(2018, 12, 25) }

              before { subject.call }

              it 'does NOT create slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to be_empty
              end
            end
          end
        end
      end
    end
  end
end
