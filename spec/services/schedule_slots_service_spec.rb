describe ScheduleSlotsService do
  include ActiveSupport::Testing::TimeHelpers

  context '#call' do
    let(:date_times_range) do
      ->(start_date_time: , end_date_time:) {
        return (start_date_time.to_datetime.to_i..end_date_time.to_datetime.to_i).step(30.minutes).map { |d| Time.at(d).utc }
      }
    end

    subject { ScheduleSlotsService.new(schedule) }
    let(:employee_driving_school) { schedule.employee_driving_school }

    context "when driving school has time zone set to 'Poland'" do
      before { employee_driving_school.driving_school.update(time_zone: 'Poland') }

      context 'when holidays_enrollment_enabled set to true' do
        before { employee_driving_school.driving_school.create_schedule_settings_set(holidays_enrollment_enabled: true) }

        # winter time +01:00
        context 'when schedule is set on 2018-02-05(monday) 09:47:12' do
          before { travel_to Time.new(2018, 2, 5, 9, 47, 12, '+01:00') }

          context 'when current_template is set and new_template_binding_from is set to past' do
            let(:schedule) do
              create(:schedule,
                     repetition_period_in_weeks: 2,
                     new_template_binding_from: 1.year.from_now,
                     current_template: {
                       monday: (16..31).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: (16..31).to_a,
                       thursday: (16..31).to_a,
                       friday: (16..31).to_a,
                       saturday: (16..19).to_a,
                       sunday: [],
                     }
              )
            end

            context 'when there are NO already existing booked slots' do
              before do
                create(:slot, start_time: DateTime.new(2018, 2, 7, 7, 30, 0, '+01:00'), employee_driving_school: employee_driving_school)
                subject.call
              end

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-02-05 10:00 +01:00', end_date_time: '2018-02-05 15:30 +01:00'),# Monday
                    date_times_range.call(start_date_time: '2018-02-06 08:00 +01:00', end_date_time: '2018-02-06 15:30 +01:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-02-07 08:00 +01:00', end_date_time: '2018-02-07 15:30 +01:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-02-08 08:00 +01:00', end_date_time: '2018-02-08 15:30 +01:00'),# Thursday
                    date_times_range.call(start_date_time: '2018-02-09 08:00 +01:00', end_date_time: '2018-02-09 15:30 +01:00'),# Friday
                    date_times_range.call(start_date_time: '2018-02-10 08:00 +01:00', end_date_time: '2018-02-10 09:30 +01:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-02-12 08:00 +01:00', end_date_time: '2018-02-12 15:30 +01:00'),# Monday
                    date_times_range.call(start_date_time: '2018-02-13 08:00 +01:00', end_date_time: '2018-02-13 15:30 +01:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-02-14 08:00 +01:00', end_date_time: '2018-02-14 15:30 +01:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-02-15 08:00 +01:00', end_date_time: '2018-02-15 15:30 +01:00'),# Thursday
                    date_times_range.call(start_date_time: '2018-02-16 08:00 +01:00', end_date_time: '2018-02-16 15:30 +01:00'),# Friday
                    date_times_range.call(start_date_time: '2018-02-17 08:00 +01:00', end_date_time: '2018-02-17 09:30 +01:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-02-19 08:00 +01:00', end_date_time: '2018-02-19 15:30 +01:00') # Monday
                  ].flatten
                )
              end
            end

            context 'when there are already existing booked slots' do
              let!(:slot_1) { create(:slot, :booked, start_time: DateTime.new(2018, 2, 8, 8, 30, 0, '+01:00'), employee_driving_school: employee_driving_school) }
              let!(:slot_2) { create(:slot, :booked, start_time: DateTime.new(2018, 2, 6, 7, 30, 0, '+01:00'), employee_driving_school: employee_driving_school) }

              before { subject.call }

              it 'creates and leaves already booked slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-02-05 10:00 +01:00', end_date_time: '2018-02-05 15:30 +01:00'),# Monday
                    date_times_range.call(start_date_time: '2018-02-06 08:00 +01:00', end_date_time: '2018-02-06 15:30 +01:00'),# Tuesday
                    slot_2.start_time, # Tuesday
                    date_times_range.call(start_date_time: '2018-02-07 08:00 +01:00', end_date_time: '2018-02-07 15:30 +01:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-02-08 08:00 +01:00', end_date_time: '2018-02-08 15:30 +01:00'),# Thursday
                    date_times_range.call(start_date_time: '2018-02-09 08:00 +01:00', end_date_time: '2018-02-09 15:30 +01:00'),# Friday
                    date_times_range.call(start_date_time: '2018-02-10 08:00 +01:00', end_date_time: '2018-02-10 09:30 +01:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-02-12 08:00 +01:00', end_date_time: '2018-02-12 15:30 +01:00'),# Monday
                    date_times_range.call(start_date_time: '2018-02-13 08:00 +01:00', end_date_time: '2018-02-13 15:30 +01:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-02-14 08:00 +01:00', end_date_time: '2018-02-14 15:30 +01:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-02-15 08:00 +01:00', end_date_time: '2018-02-15 15:30 +01:00'),# Thursday
                    date_times_range.call(start_date_time: '2018-02-16 08:00 +01:00', end_date_time: '2018-02-16 15:30 +01:00'),# Friday
                    date_times_range.call(start_date_time: '2018-02-17 08:00 +01:00', end_date_time: '2018-02-17 09:30 +01:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-02-19 08:00 +01:00', end_date_time: '2018-02-19 15:30 +01:00') # Monday
                  ].flatten
                )
              end

              it 'does not override already booked slots' do
                expect(slot_1.reload).not_to be_nil
                expect(slot_2.reload).not_to be_nil
              end
            end
          end

          context 'when current_template is set and new_template_binding_from is set and new_template is set' do
            let(:schedule) do
              create(:schedule,
                     repetition_period_in_weeks: 2,
                     new_template_binding_from: Date.new(2018, 2, 12),
                     current_template: {
                       monday: (16..31).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: (16..31).to_a,
                       thursday: (16..31).to_a,
                       friday: (16..31).to_a,
                       saturday: (16..19).to_a,
                       sunday: [],
                     },
                     new_template: {
                       monday: (32..47).to_a,
                       tuesday: (32..47).to_a,
                       wednesday: (32..47).to_a,
                       thursday: [],
                       friday: [],
                       saturday: [],
                       sunday: [],
                     }
              )
            end

            context 'when there are NO already existing booked slots' do
              before do
                create(:slot, start_time: DateTime.new(2018, 2, 7, 7, 30, 0, '+01:00'), employee_driving_school: employee_driving_school)
                subject.call
              end

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-02-05 10:00 +01:00', end_date_time: '2018-02-05 15:30 +01:00'),# Monday
                    date_times_range.call(start_date_time: '2018-02-06 08:00 +01:00', end_date_time: '2018-02-06 15:30 +01:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-02-07 08:00 +01:00', end_date_time: '2018-02-07 15:30 +01:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-02-08 08:00 +01:00', end_date_time: '2018-02-08 15:30 +01:00'),# Thursday
                    date_times_range.call(start_date_time: '2018-02-09 08:00 +01:00', end_date_time: '2018-02-09 15:30 +01:00'),# Friday
                    date_times_range.call(start_date_time: '2018-02-10 08:00 +01:00', end_date_time: '2018-02-10 09:30 +01:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-02-12 16:00 +01:00', end_date_time: '2018-02-12 23:30 +01:00'),# Monday
                    date_times_range.call(start_date_time: '2018-02-13 16:00 +01:00', end_date_time: '2018-02-13 23:30 +01:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-02-14 16:00 +01:00', end_date_time: '2018-02-14 23:30 +01:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-02-19 16:00 +01:00', end_date_time: '2018-02-19 23:30 +01:00') # Monday
                  ].flatten
                )
              end
            end

            context 'when there are already existing booked slots' do
              let!(:slot_1) { create(:slot, :booked, start_time: DateTime.new(2018, 2, 8, 8, 30, 0, '+01:00'), employee_driving_school: employee_driving_school) }
              let!(:slot_2) { create(:slot, :booked, start_time: DateTime.new(2018, 2, 6, 7, 30, 0, '+01:00'), employee_driving_school: employee_driving_school) }

              before { subject.call }

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-02-05 10:00 +01:00', end_date_time: '2018-02-05 15:30 +01:00'),# Monday
                    date_times_range.call(start_date_time: '2018-02-06 08:00 +01:00', end_date_time: '2018-02-06 15:30 +01:00'),# Tuesday
                    slot_2.start_time, # Tuesday
                    date_times_range.call(start_date_time: '2018-02-07 08:00 +01:00', end_date_time: '2018-02-07 15:30 +01:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-02-08 08:00 +01:00', end_date_time: '2018-02-08 15:30 +01:00'),# Thursday
                    date_times_range.call(start_date_time: '2018-02-09 08:00 +01:00', end_date_time: '2018-02-09 15:30 +01:00'),# Friday
                    date_times_range.call(start_date_time: '2018-02-10 08:00 +01:00', end_date_time: '2018-02-10 09:30 +01:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-02-12 16:00 +01:00', end_date_time: '2018-02-12 23:30 +01:00'),# Monday
                    date_times_range.call(start_date_time: '2018-02-13 16:00 +01:00', end_date_time: '2018-02-13 23:30 +01:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-02-14 16:00 +01:00', end_date_time: '2018-02-14 23:30 +01:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-02-19 16:00 +01:00', end_date_time: '2018-02-19 23:30 +01:00') # Monday
                  ].flatten
                )
              end

              it 'does not override already booked slots' do
                expect(slot_1.reload).not_to be_nil
                expect(slot_2.reload).not_to be_nil
              end
            end
          end
        end

        # summer time +02:00
        context 'when schedule is set on 2018-08-08(wednesday) 11:12:45' do
          before { travel_to Time.new(2018, 8, 8, 11, 12, 45, '+02:00') }

          context 'when current_template is set and new_template_binding_from is set to past' do
            let(:schedule) do
              create(:schedule,
                     repetition_period_in_weeks: 1,
                     new_template_binding_from: nil,
                     current_template: {
                       monday: (0..10).to_a + (30..47).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: (5..15).to_a + (20..23).to_a,
                       thursday: (16..31).to_a,
                       friday: [],
                       saturday: (32..47).to_a,
                       sunday: (0..1).to_a,
                     }
              )
            end

            context 'when there are NO already existing booked slots' do
              before do
                create(:slot, start_time: DateTime.new(2018, 8, 11, 4, 30, 0, '+02:00'), employee_driving_school: employee_driving_school)
                subject.call
              end

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-08-08 11:30 +02:00', end_date_time: '2018-08-08 11:30 +02:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-08-09 08:00 +02:00', end_date_time: '2018-08-09 15:30 +02:00'),# Thursday
                    date_times_range.call(start_date_time: '2018-08-11 16:00 +02:00', end_date_time: '2018-08-11 23:30 +02:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-08-12 00:00 +02:00', end_date_time: '2018-08-12 00:30 +02:00'),# Sunday
                    date_times_range.call(start_date_time: '2018-08-13 00:00 +02:00', end_date_time: '2018-08-13 05:00 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-08-13 15:00 +02:00', end_date_time: '2018-08-13 23:30 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-08-14 08:00 +02:00', end_date_time: '2018-08-14 15:30 +02:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-08-15 02:30 +02:00', end_date_time: '2018-08-15 07:30 +02:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-08-15 10:00 +02:00', end_date_time: '2018-08-15 11:30 +02:00'),# Wednesday
                  ].flatten
                )
              end
            end

            context 'when there are already existing booked slots' do
              let!(:slot_1) { create(:slot, :booked, start_time: DateTime.new(2018, 8, 9, 8, 30, 0, '+02:00'), employee_driving_school: employee_driving_school) }
              let!(:slot_2) { create(:slot, :booked, start_time: DateTime.new(2018, 8, 10, 8, 30, 0, '+02:00'), employee_driving_school: employee_driving_school) }

              before { subject.call }

              it 'creates and leaves already booked slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-08-08 11:30 +02:00', end_date_time: '2018-08-08 11:30 +02:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-08-09 08:00 +02:00', end_date_time: '2018-08-09 15:30 +02:00'),# Thursday
                    slot_2.start_time, # Thursday
                    date_times_range.call(start_date_time: '2018-08-11 16:00 +02:00', end_date_time: '2018-08-11 23:30 +02:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-08-12 00:00 +02:00', end_date_time: '2018-08-12 00:30 +02:00'),# Sunday
                    date_times_range.call(start_date_time: '2018-08-13 00:00 +02:00', end_date_time: '2018-08-13 05:00 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-08-13 15:00 +02:00', end_date_time: '2018-08-13 23:30 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-08-14 08:00 +02:00', end_date_time: '2018-08-14 15:30 +02:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-08-15 02:30 +02:00', end_date_time: '2018-08-15 07:30 +02:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-08-15 10:00 +02:00', end_date_time: '2018-08-15 11:30 +02:00'),# Wednesday
                  ].flatten
                )
              end

              it 'does not override already booked slots' do
                expect(slot_1.reload).not_to be_nil
                expect(slot_2.reload).not_to be_nil
              end
            end
          end

          context 'when current_template is set and new_template_binding_from is set and new_template is set' do
            let(:schedule) do
              create(:schedule,
                     repetition_period_in_weeks: 1,
                     new_template_binding_from: Date.new(2018, 8, 12),
                     current_template: {
                       monday: (0..10).to_a + (30..47).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: (5..15).to_a + (20..23).to_a,
                       thursday: (16..31).to_a,
                       friday: [],
                       saturday: (32..47).to_a,
                       sunday: (0..1).to_a,
                     },
                     new_template: {
                       monday: (16..31).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: [],
                       thursday: [],
                       friday: [],
                       saturday: [],
                       sunday: [],
                     }
              )
            end

            context 'when there are NO already existing booked slots' do
              before do
                create(:slot, start_time: DateTime.new(2018, 8, 11, 4, 30, 0, '+02:00'), employee_driving_school: employee_driving_school)
                subject.call
              end

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-08-08 11:30 +02:00', end_date_time: '2018-08-08 11:30 +02:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-08-09 08:00 +02:00', end_date_time: '2018-08-09 15:30 +02:00'),# Thursday
                    date_times_range.call(start_date_time: '2018-08-11 16:00 +02:00', end_date_time: '2018-08-11 23:30 +02:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-08-13 08:00 +02:00', end_date_time: '2018-08-13 15:30 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-08-14 08:00 +02:00', end_date_time: '2018-08-14 15:30 +02:00'),# Tuesday
                  ].flatten
                )
              end
            end

            context 'when there are already existing booked slots' do
              let!(:slot_1) { create(:slot, :booked, start_time: DateTime.new(2018, 8, 9, 8, 30, 0, '+02:00'), employee_driving_school: employee_driving_school) }
              let!(:slot_2) { create(:slot, :booked, start_time: DateTime.new(2018, 8, 10, 8, 30, 0, '+02:00'), employee_driving_school: employee_driving_school) }

              before { subject.call }

              it 'creates and leaves already booked slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-08-08 11:30 +02:00', end_date_time: '2018-08-08 11:30 +02:00'),# Wednesday
                    date_times_range.call(start_date_time: '2018-08-09 08:00 +02:00', end_date_time: '2018-08-09 15:30 +02:00'),# Thursday
                    slot_2.start_time,
                    date_times_range.call(start_date_time: '2018-08-11 16:00 +02:00', end_date_time: '2018-08-11 23:30 +02:00'),# Saturday
                    date_times_range.call(start_date_time: '2018-08-13 08:00 +02:00', end_date_time: '2018-08-13 15:30 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-08-14 08:00 +02:00', end_date_time: '2018-08-14 15:30 +02:00'),# Tuesday
                  ].flatten
                )
              end

              it 'does not override already booked slots' do
                expect(slot_1.reload).not_to be_nil
                expect(slot_2.reload).not_to be_nil
              end
            end
          end
        end

        # Timezone change from winter to summer
        xcontext 'when schedule is set on 2018-03-22(thursday) 23:59:59' do
          before { travel_to Time.new(2018, 3, 22, 23, 59, 59, '+01:00') }

          let(:schedule) do
            create(:schedule,
                   repetition_period_in_weeks: 1,
                   current_template: {
                     monday: (0..15).to_a,
                     tuesday: (0..15).to_a,
                     wednesday: (0..15).to_a,
                     thursday: (0..15).to_a,
                     friday: (0..15).to_a,
                     saturday: (0..15).to_a,
                     sunday: (0..15).to_a,
                   }
            )
          end

          it 'creates proper slots' do
            expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
              [
                date_times_range.call(start_date_time: '2018-03-23 00:00 +01:00', end_date_time: '2018-03-23 07:30 +01:00'),# Thursday
                date_times_range.call(start_date_time: '2018-03-24 00:00 +01:00', end_date_time: '2018-03-24 07:30 +01:00'),# Friday
                date_times_range.call(start_date_time: '2018-03-25 00:00 +01:00', end_date_time: '2018-03-25 07:30 +02:00'),# Saturday
                date_times_range.call(start_date_time: '2018-03-26 00:00 +02:00', end_date_time: '2018-03-26 07:30 +02:00'),# Sunday
                date_times_range.call(start_date_time: '2018-03-27 00:00 +02:00', end_date_time: '2018-03-27 07:30 +02:00'),# Monday
                date_times_range.call(start_date_time: '2018-03-28 00:00 +02:00', end_date_time: '2018-03-28 07:30 +02:00'),# Tuesday
                date_times_range.call(start_date_time: '2018-03-29 00:00 +02:00', end_date_time: '2018-03-29 07:30 +02:00'),# Wednesday
              ].flatten
            )
          end
        end

        # Timezone change from summer to winter
        xcontext 'when schedule is set on 2018-10-26(friday) 00:00:00' do

          before { travel_to Time.new(2018, 10, 26, 0, 0, 0, '+02:00') }

          let(:schedule) do
            create(:schedule,
                   repetition_period_in_weeks: 1,
                   current_template: {
                     monday: (0..15).to_a,
                     tuesday: (0..15).to_a,
                     wednesday: (0..15).to_a,
                     thursday: (0..15).to_a,
                     friday: (0..15).to_a,
                     saturday: (0..15).to_a,
                     sunday: (0..15).to_a,
                   }
            )
          end

          it 'creates proper slots' do
            expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
              [
                date_times_range.call(start_date_time: '2018-10-26 00:30 +02:00', end_date_time: '2018-10-26 07:30 +02:00'),# Friday
                date_times_range.call(start_date_time: '2018-10-27 00:00 +02:00', end_date_time: '2018-10-27 07:30 +02:00'),# Saturday
                date_times_range.call(start_date_time: '2018-10-28 00:00 +02:00', end_date_time: '2018-10-28 07:30 +01:00'),# Sunday
                date_times_range.call(start_date_time: '2018-10-29 00:00 +01:00', end_date_time: '2018-10-29 07:30 +01:00'),# Monday
                date_times_range.call(start_date_time: '2018-10-30 00:00 +01:00', end_date_time: '2018-10-30 07:30 +01:00'),# Tuesday
                date_times_range.call(start_date_time: '2018-10-31 00:00 +01:00', end_date_time: '2018-10-31 07:30 +01:00'),# Wednesday
                date_times_range.call(start_date_time: '2018-11-01 00:00 +01:00', end_date_time: '2018-11-01 07:30 +01:00'),# Thursday
              ].flatten
            )
          end
        end
      end

      context 'when holidays_enrollment_enabled set to false' do
        before { employee_driving_school.driving_school.create_schedule_settings_set(holidays_enrollment_enabled: false) }

        context 'when schedule is set on 2018-05-28(monday) 09:22:36' do
          before { travel_to Time.new(2018, 05, 28, 9, 22, 36, '+02:00') }

          context 'when current_template is set and new_template_binding_from is set to past' do
            let(:schedule) do
              create(:schedule,
                     repetition_period_in_weeks: 1,
                     new_template_binding_from: 1.year.from_now,
                     current_template: {
                       monday: (16..31).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: (16..31).to_a,
                       thursday: (16..31).to_a,
                       friday: (16..31).to_a,
                       saturday: [],
                       sunday: [],
                     }
              )
            end

            context 'when there are NO already existing booked slots' do
              before do
                create(:slot, start_time: DateTime.new(2018, 5, 29, 20, 30, 0, '+02:00'), employee_driving_school: employee_driving_school)
                subject.call
              end

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-05-28 09:30 +02:00', end_date_time: '2018-05-28 15:30 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-05-29 08:00 +02:00', end_date_time: '2018-05-29 15:30 +02:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-05-30 08:00 +02:00', end_date_time: '2018-05-30 15:30 +02:00'),# Wednesday
                    # Holidays on thursday
                    date_times_range.call(start_date_time: '2018-06-01 08:00 +02:00', end_date_time: '2018-06-01 15:30 +02:00'),# Friday
                    date_times_range.call(start_date_time: '2018-06-04 08:00 +02:00', end_date_time: '2018-06-04 15:30 +02:00'),# Monday
                  ].flatten
                )
              end
            end

            context 'when there are already existing booked slots' do
              let!(:slot_1) { create(:slot, :booked, start_time: DateTime.new(2018, 5, 29, 8, 30, 0, '+02:00'), employee_driving_school: employee_driving_school) }
              let!(:slot_2) { create(:slot, :booked, start_time: DateTime.new(2018, 5, 29, 20, 30, 0, '+02:00'), employee_driving_school: employee_driving_school) }

              before { subject.call }

              it 'creates and leaves already booked slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-05-28 09:30 +02:00', end_date_time: '2018-05-28 15:30 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-05-29 08:00 +02:00', end_date_time: '2018-05-29 15:30 +02:00'),# Tuesday
                    slot_2.start_time, # Tuesday
                    date_times_range.call(start_date_time: '2018-05-30 08:00 +02:00', end_date_time: '2018-05-30 15:30 +02:00'),# Wednesday
                    # Holidays on thursday
                    date_times_range.call(start_date_time: '2018-06-01 08:00 +02:00', end_date_time: '2018-06-01 15:30 +02:00'),# Friday
                    date_times_range.call(start_date_time: '2018-06-04 08:00 +02:00', end_date_time: '2018-06-04 15:30 +02:00'),# Monday
                  ].flatten
                )
              end

              it 'does not override already booked slots' do
                expect(slot_1.reload).not_to be_nil
                expect(slot_2.reload).not_to be_nil
              end
            end
          end

          context 'when current_template is set and new_template_binding_from is set and new_template is set' do
            let(:schedule) do
              create(:schedule,
                     repetition_period_in_weeks: 1,
                     new_template_binding_from: Date.new(2018, 5, 31),
                     current_template: {
                       monday: (16..31).to_a,
                       tuesday: (16..31).to_a,
                       wednesday: (16..31).to_a,
                       thursday: (16..31).to_a,
                       friday: (16..31).to_a,
                       saturday: [],
                       sunday: [],
                     },
                     new_template: {
                       monday: [],
                       tuesday: (16..31).to_a,
                       wednesday: [],
                       thursday: [],
                       friday: [],
                       saturday: [],
                       sunday: (16..31).to_a,
                     }
              )
            end

            context 'when there are NO already existing booked slots' do
              before do
                create(:slot, start_time: DateTime.new(2018, 5, 29, 20, 30, 0, '+02:00'), employee_driving_school: employee_driving_school)
                subject.call
              end

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-05-28 09:30 +02:00', end_date_time: '2018-05-28 15:30 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-05-29 08:00 +02:00', end_date_time: '2018-05-29 15:30 +02:00'),# Tuesday
                    date_times_range.call(start_date_time: '2018-05-30 08:00 +02:00', end_date_time: '2018-05-30 15:30 +02:00'),# Wednesday
                    # Holidays on thursday
                    date_times_range.call(start_date_time: '2018-06-03 08:00 +02:00', end_date_time: '2018-06-03 15:30 +02:00'),# Monday
                  ].flatten
                )
              end
            end

            context 'when there are already existing booked slots' do
              let!(:slot_1) { create(:slot, :booked, start_time: DateTime.new(2018, 5, 29, 8, 30, 0, '+02:00'), employee_driving_school: employee_driving_school) }
              let!(:slot_2) { create(:slot, :booked, start_time: DateTime.new(2018, 5, 29, 20, 30, 0, '+02:00'), employee_driving_school: employee_driving_school) }

              before { subject.call }

              it 'creates proper slots' do
                expect(employee_driving_school.slots.pluck(:start_time)).to match_array(
                  [
                    date_times_range.call(start_date_time: '2018-05-28 09:30 +02:00', end_date_time: '2018-05-28 15:30 +02:00'),# Monday
                    date_times_range.call(start_date_time: '2018-05-29 08:00 +02:00', end_date_time: '2018-05-29 15:30 +02:00'),# Tuesday
                    slot_2.start_time,# Tuesday
                    date_times_range.call(start_date_time: '2018-05-30 08:00 +02:00', end_date_time: '2018-05-30 15:30 +02:00'),# Wednesday
                    # Holidays on thursday
                    date_times_range.call(start_date_time: '2018-06-03 08:00 +02:00', end_date_time: '2018-06-03 15:30 +02:00'),# Monday
                  ].flatten
                )
              end

              it 'does not override already booked slots' do
                expect(slot_1.reload).not_to be_nil
                expect(slot_2.reload).not_to be_nil
              end
            end
          end
        end
      end
    end
  end
end
