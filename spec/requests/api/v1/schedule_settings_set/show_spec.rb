describe 'GET /api/v1/driving_schools/:driving_school_id/schedule_settings_set' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }
  let!(:employee_driving_school) { create(:employee_driving_school, is_owner: is_owner, employee: employee, driving_school: driving_school) }
  let(:driving_school) { create(:driving_school, :with_schedule_settings_set) }

  let(:is_owner) { false }

  let(:response_keys) { %w(id holidays_enrollment_enabled last_minute_booking_enabled) }

  before do
    get "/api/v1/driving_schools/#{driving_school_id}/schedule_settings_set", headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'when current_user is owner of driving_school' do
        let(:is_owner) { true }

        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            sss = driving_school.schedule_settings_set
            expect(subject).to include(
                                 'holidays_enrollment_enabled' => sss.holidays_enrollment_enabled,
                                 'last_minute_booking_enabled' => sss.last_minute_booking_enabled
                               )
          end
        end
      end

      context 'when current_user is NOT owner of driving_school' do
        it 'returns 401 http status code' do
          expect(response.status).to eq 401
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
    let(:driving_school_id) { driving_school.id }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
