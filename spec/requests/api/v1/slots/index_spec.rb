describe 'GET /api/v1/driving_schools/:driving_school_id/slots' do
  let(:student) { create(:student) }
  let(:employee_1) { create(:employee) }
  let(:employee_2) { create(:employee) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school_1) do
    create(:employee_driving_school,
           employee: employee_1,
           driving_school: driving_school,
           status: :active)
  end

  let!(:employee_driving_school_2) do
    create(:employee_driving_school,
           employee: employee_2,
           driving_school: driving_school,
           status: :active)
  end

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end

  let!(:slot_1) do
    create(:slot,
           employee_driving_school: employee_driving_school_1,
           start_time: 1.day.from_now)
  end

  let!(:slot_2) do
    create(:slot,
           employee_driving_school: employee_driving_school_1,
           start_time: 2.day.from_now)
  end

  let!(:slot_3) do
    create(:slot,
           employee_driving_school: employee_driving_school_2,
           start_time: 3.day.from_now)
  end

  let(:params) { {} }

  let(:response_keys) do
    %w[
      id start_time driving_lesson_id release_at locking_user_id employee_id
    ]
  end

  before do
    get api_v1_driving_school_slots_path(driving_school.id),
        headers: current_user.create_new_auth_token,
        params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee_1 }

    it 'returned records contain proper keys' do
      expect(json_response.first.keys).to match_array response_keys
    end

    it 'response contains driving lesson attributes' do
      expect(json_response.find { |i| i['id'] == slot_1.id }).to include(
        'id' => slot_1.id,
        'employee_id' => slot_1.employee_driving_school.employee_id,
        # 'start_time' => slot_1.start_time,
        'driving_lesson_id' => slot_1.driving_lesson_id
      )
    end

    context 'with by_start_time param' do
      let(:params) do
        {
          by_start_time: {
            from: 1.day.from_now - 1.hour,
            to: 2.day.from_now + 1.hour
          }
        }
      end

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          slot_1.id, slot_2.id
        ]
      end
    end

    context 'with employee_id param' do
      let(:params) { { employee_id: employee_2.id } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [slot_3.id]
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    it 'returned records contain proper keys' do
      expect(json_response.first.keys).to match_array response_keys
    end

    it 'response contains driving lesson attributes' do
      expect(json_response.find { |i| i['id'] == slot_1.id }).to include(
        'id' => slot_1.id,
        'employee_id' => slot_1.employee_driving_school.employee_id,
        # 'start_time' => slot_1.start_time,
        'driving_lesson_id' => slot_1.driving_lesson_id
      )
    end

    context 'with by_start_time param' do
      let(:params) do
        {
          by_start_time: {
            from: 1.day.from_now - 1.hour,
            to: 2.day.from_now + 1.hour
          }
        }
      end

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          slot_1.id, slot_2.id
        ]
      end
    end

    context 'with employee_id param' do
      let(:params) { { employee_id: employee_2.id } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [slot_3.id]
      end
    end
  end
end
