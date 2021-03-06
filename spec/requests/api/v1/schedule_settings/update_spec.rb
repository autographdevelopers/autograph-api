describe 'PUT /api/v1/driving_schools/:driving_school_id/schedule_settings' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           employee: employee,
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

  let(:valid_params) do
    {
      schedule_settings: {
        holidays_enrollment_enabled: true,
        last_minute_booking_enabled: false,
        minimum_slots_count_per_driving_lesson: 1,
        maximum_slots_count_per_driving_lesson: 4,
        booking_advance_period_in_weeks: 12,
        can_student_book_driving_lesson: false,
        valid_time_frames: {
          'monday' => (16..31).to_a,
          'tuesday' => (16..31).to_a,
          'wednesday' => (32..47).to_a,
          'thursday' => (16..31).to_a,
          'friday' => (16..31).to_a,
          'saturday' => (0..15).to_a,
          'sunday' => []
        }
      }
    }
  end

  before do
    put "/api/v1/driving_schools/#{driving_school_id}/schedule_settings",
        headers: current_user.create_new_auth_token, params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'when current_user is owner of driving_school' do
        let(:is_owner) { true }

        context 'with VALID params' do
          let(:params) { valid_params }

          it 'returns 200 http status code' do
            expect(response.status).to eq 200
          end

          it 'updates EmployeeNotificationsSettings record' do
            schedule_settings = driving_school.schedule_settings.reload
            expect(schedule_settings.attributes).to include(
              'holidays_enrollment_enabled' => true,
              'last_minute_booking_enabled' => false,
              'minimum_slots_count_per_driving_lesson' => 1,
              'maximum_slots_count_per_driving_lesson' => 4,
              'can_student_book_driving_lesson' => false,
              'booking_advance_period_in_weeks' => 12
            )
          end

          context 'response body contains proper' do
            subject { json_response }

            it 'keys' do
              expect(subject.keys).to match_array response_keys
            end

            it 'attributes' do
              expect(subject).to include(
                'holidays_enrollment_enabled' => true,
                'last_minute_booking_enabled' => false,
                'minimum_slots_count_per_driving_lesson' => 1,
                'maximum_slots_count_per_driving_lesson' => 4,
                'can_student_book_driving_lesson' => false,
                'booking_advance_period_in_weeks' => 12
              )
            end
          end
        end

        context 'with INVALID params' do
          context 'all fields blank' do
            let(:params) do
              {
                schedule_settings: {
                  holidays_enrollment_enabled: '',
                  last_minute_booking_enabled: '',
                  minimum_slots_count_per_driving_lesson: '',
                  maximum_slots_count_per_driving_lesson: '',
                  can_student_book_driving_lesson: '',
                  booking_advance_period_in_weeks: ''
                }
              }
            end

            it 'returns 422 http status code' do
              expect(response.status).to eq 422
            end

            it 'response contains proper error messages' do
              expect(json_response).to include(
                'holidays_enrollment_enabled' => ['is not included in the list'],
                'last_minute_booking_enabled' => ['is not included in the list'],
                'can_student_book_driving_lesson' => ['is not included in the list'],
                'minimum_slots_count_per_driving_lesson' =>  ["can't be blank", 'is not a number'],
                'maximum_slots_count_per_driving_lesson' => ["can't be blank", 'is not a number'],
                'booking_advance_period_in_weeks' => ["can't be blank", 'is not included in the list']
              )
            end
          end
        end
      end

      context 'when current_user is NOT owner of driving_school' do
        let(:params) { valid_params }
        let(:is_owner) { false }

        it 'returns 401 http status code' do
          expect(response.status).to eq 401
        end
      end
    end

    context 'when is NOT accessing his driving school' do
      let(:driving_school_id) { create(:driving_school).id }
      let(:params) { valid_params }
      let(:is_owner) { true }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }
    let(:driving_school_id) { driving_school.id }
    let(:params) { valid_params }
    let(:is_owner) { false }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
