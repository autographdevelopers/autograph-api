describe 'GET /api/v1/driving_schools/:driving_school_id/schedule_boundaries' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }
  let!(:student_driving_school) { create(:student_driving_school, student: student, driving_school: driving_school) }
  let!(:employee_driving_school) { create(:employee_driving_school, employee: employee, driving_school: driving_school) }
  let(:driving_school) { create(:driving_school, :with_schedule_settings) }

  let!(:schedule_boundaries) { create_list(:schedule_boundary, 2, driving_school: driving_school) }

  let(:response_keys) { %w(id weekday start_time end_time) }

  before do
    get "/api/v1/driving_schools/#{driving_school_id}/schedule_boundaries", headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array schedule_boundaries.pluck(:id)
      end

      context 'response contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.first.keys).to match_array response_keys
        end

        it 'attributes' do
          expect(subject.find { |i| i['id'] == schedule_boundaries.first.id }).to include(
                                                                                    'weekday' => schedule_boundaries.first.weekday,
                                                                                    'start_time' => schedule_boundaries.first.start_time,
                                                                                    'end_time' => schedule_boundaries.first.end_time
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

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array schedule_boundaries.pluck(:id)
      end

      context 'response contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.first.keys).to match_array response_keys
        end

        it 'attributes' do
          expect(subject.find { |i| i['id'] == schedule_boundaries.first.id }).to include(
                                                                                    'weekday' => schedule_boundaries.first.weekday,
                                                                                    'start_time' => schedule_boundaries.first.start_time,
                                                                                    'end_time' => schedule_boundaries.first.end_time
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
