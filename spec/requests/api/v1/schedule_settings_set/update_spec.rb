describe 'PUT /api/v1/driving_schools/:driving_school_id/schedule_settings_set' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }
  let!(:employee_driving_school) { create(:employee_driving_school, is_owner: is_owner, employee: employee, driving_school: driving_school) }
  let(:driving_school) { create(:driving_school, :with_schedule_settings_set) }

  let(:response_keys) { %w(id holidays_enrollment_enabled last_minute_booking_enabled) }

  let(:valid_params) do
    {
      schedule_settings_set: {
        holidays_enrollment_enabled: true,
        last_minute_booking_enabled: false
      }
    }
  end

  before do
    put "/api/v1/driving_schools/#{driving_school_id}/schedule_settings_set",
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

          it 'updates EmployeeNotificationsSettingsSet record' do
            schedule_settings_set = driving_school.schedule_settings_set.reload
            expect(schedule_settings_set.attributes).to include(
                                                          'holidays_enrollment_enabled' => true,
                                                          'last_minute_booking_enabled' => false
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
                                   'last_minute_booking_enabled' => false
                                 )
            end
          end
        end

        context 'with INVALID params' do
          context 'all fields blank' do
            let(:params) do
              {
                schedule_settings_set: {
                  holidays_enrollment_enabled: '',
                  last_minute_booking_enabled: ''
                }
              }
            end

            it 'returns 422 http status code' do
              expect(response.status).to eq 422
            end

            it 'response contains proper error messages' do
              expect(json_response).to include(
                                         'holidays_enrollment_enabled' => ['is not included in the list'],
                                         'last_minute_booking_enabled' => ['is not included in the list']
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
