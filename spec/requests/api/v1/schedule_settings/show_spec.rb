describe 'GET /api/v1/driving_schools/:driving_school_id/schedule_settings' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school)
  end

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school)
  end

  let(:driving_school) { create(:driving_school, :with_schedule_settings) }

  let(:response_keys) do
    %w[
      id holidays_enrollment_enabled last_minute_booking_enabled
      valid_time_frames minimum_slots_count_per_driving_lesson
      maximum_slots_count_per_driving_lesson can_student_book_driving_lesson
      booking_advance_period_in_weeks
    ]
  end

  before do
    get "/api/v1/driving_schools/#{driving_school_id}/schedule_settings",
        headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      context 'response body contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.keys).to match_array response_keys
        end

        it 'attributes' do
          ss = driving_school.schedule_settings
          expect(subject).to include(
            'holidays_enrollment_enabled' => ss.holidays_enrollment_enabled,
            'last_minute_booking_enabled' => ss.last_minute_booking_enabled,
            'minimum_slots_count_per_driving_lesson' => ss.minimum_slots_count_per_driving_lesson,
            'maximum_slots_count_per_driving_lesson' => ss.maximum_slots_count_per_driving_lesson,
            'can_student_book_driving_lesson' => ss.can_student_book_driving_lesson,
            'booking_advance_period_in_weeks' => ss.booking_advance_period_in_weeks
          )
        end
      end
    end

    context 'when is NOT accessing his driving school' do
      let(:driving_school_id) { create(:driving_school).id }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      context 'response body contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.keys).to match_array response_keys
        end

        it 'attributes' do
          ss = driving_school.schedule_settings
          expect(subject).to include(
            'holidays_enrollment_enabled' => ss.holidays_enrollment_enabled,
            'last_minute_booking_enabled' => ss.last_minute_booking_enabled,
            'minimum_slots_count_per_driving_lesson' => ss.minimum_slots_count_per_driving_lesson,
            'maximum_slots_count_per_driving_lesson' => ss.maximum_slots_count_per_driving_lesson,
            'can_student_book_driving_lesson' => ss.can_student_book_driving_lesson,
            'booking_advance_period_in_weeks' => ss.booking_advance_period_in_weeks
          )
        end
      end
    end

    context 'when is NOT accessing his driving school' do
      let(:driving_school_id) { create(:driving_school).id }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end
end
