describe 'POST /api/v1/driving_schools/:driving_school_id/schedule_boundaries' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }
  let!(:student_driving_school) { create(:student_driving_school, student: student, driving_school: driving_school) }
  let!(:employee_driving_school) { create(:employee_driving_school, is_owner: is_owner, employee: employee, driving_school: driving_school) }
  let(:driving_school) { create(:driving_school, :with_schedule_settings_set) }

  let(:response_keys) { %w(id weekday start_time end_time) }

  let(:valid_params) do
    {
      schedule_boundaries: [
        {
          weekday: 'monday',
          start_time: DateTime.new(2000, 1, 1, 6, 30, 00),
          end_time: DateTime.new(2000, 1, 1, 20, 30, 00),
        },
        {
          weekday: 'tuesday',
          start_time: DateTime.new(2000, 1, 1, 8, 30, 00),
          end_time: DateTime.new(2000, 1, 1, 20, 30, 00),
        },
      ]
    }
  end

  before do
    post "/api/v1/driving_schools/#{driving_school_id}/schedule_boundaries",
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

          it 'creates proper amount of ScheduleBoundary records' do
            expect(ScheduleBoundary.count).to eq 2
          end

          it 'creates proper ScheduleBoundary records' do
            expect(ScheduleBoundary.first.attributes).to include(
                                                           'weekday' => params[:schedule_boundaries].first[:weekday],
                                                           'start_time' => params[:schedule_boundaries].first[:start_time],
                                                           'end_time' => params[:schedule_boundaries].first[:end_time]
                                                         )
          end

          context 'response contains proper' do
            subject { json_response }

            it 'keys' do
              expect(subject.first.keys).to match_array response_keys
            end

            it 'attributes' do
              expect(subject.first).to include(
                                         'weekday' => params[:schedule_boundaries].first[:weekday],
                                         'start_time' => params[:schedule_boundaries].first[:start_time],
                                         'end_time' => params[:schedule_boundaries].first[:end_time]
                                       )
            end
          end
        end

        context 'with INVALID params' do
          context 'all fields blank' do
            let(:params) do
              {
                schedule_boundaries: [
                  {
                    weekday: '',
                    start_time: '',
                    end_time: ''
                  }
                ]
              }
            end

            it 'returns 422 http status code' do
              expect(response.status).to eq 422
            end

            it 'response contains proper error messages' do
              expect(json_response).to include(
                                         'weekday' => ["can't be blank"],
                                         'start_time' => ["can't be blank"],
                                         'end_time' => ["can't be blank"]
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