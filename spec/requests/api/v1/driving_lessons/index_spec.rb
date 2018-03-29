describe 'GET /api/v1/driving_schools/:driving_school_id/driving_lessons' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           is_owner: is_owner,
           can_modify_schedules: can_modify_schedules,
           status: :active)
  end

  let(:is_owner) { false }
  let(:can_modify_schedules) { false }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end

  let!(:driving_lesson_1) do
    create(:driving_lesson,
           employee: employee,
           student: student,
           driving_school: driving_school,
           start_time: 1.day.from_now)
  end

  let!(:driving_lesson_2) do
    create(:driving_lesson,
           employee: employee,
           student: create(:student),
           driving_school: driving_school,
           status: :canceled,
           start_time: 1.day.from_now)
  end

  let!(:driving_lesson_3) do
    create(:driving_lesson,
           employee: create(:employee),
           student: student,
           driving_school: driving_school,
           start_time: 1.day.from_now)
  end

  let!(:driving_lesson_4) do
    create(:driving_lesson,
           employee: create(:employee),
           student: student,
           driving_school: driving_school,
           status: :canceled,
           start_time: 1.day.ago)
  end

  let!(:driving_lesson_5) do
    create(:driving_lesson,
           employee: employee,
           student: create(:student),
           driving_school: driving_school,
           start_time: 1.day.ago)
  end

  let!(:driving_lesson_6) do
    create(:driving_lesson,
           employee: employee,
           student: student,
           driving_school: driving_school,
           status: :canceled,
           start_time: 1.day.ago)
  end

  let(:params) { {} }

  let(:response_keys) { %w[employee student slots id start_time status] }

  before do
    get "/api/v1/driving_schools/#{driving_school.id}/driving_lessons",
        headers: current_user.create_new_auth_token,
        params: params
  end

  let(:current_user) { employee }

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    it 'returned records contain proper keys' do
      expect(json_response.first.keys).to match_array response_keys
    end

    it 'response contains driving lesson attributes' do
      expect(json_response.find { |i| i['id'] == driving_lesson_1.id }).to include(
        'id' => driving_lesson_1.id,
        # 'start_time' => driving_lesson_1.start_time.to_s,
        'employee' => {
          'id' => driving_lesson_1.employee.id,
          'name' => driving_lesson_1.employee.name,
          'surname' => driving_lesson_1.employee.surname,
        },
        'student' => {
          'id' => driving_lesson_1.student.id,
          'name' => driving_lesson_1.student.name,
          'surname' => driving_lesson_1.student.surname,
        }
      )
    end

    context 'with employee_id param' do
      let(:params) { { employee_id: employee.id } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id, driving_lesson_2.id,
          driving_lesson_5.id, driving_lesson_6.id
        ]
      end
    end

    context 'with student_id param' do
      let(:params) { { student_id: student.id } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id, driving_lesson_3.id,
          driving_lesson_4.id, driving_lesson_6.id
        ]
      end
    end

    context 'with driving_lessons_ids param' do
      let(:params) { { driving_lessons_ids: [driving_lesson_1.id, driving_lesson_2.id] } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id, driving_lesson_2.id
        ]
      end
    end

    context 'with active param' do
      let(:params) { { active: true } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id, driving_lesson_3.id, driving_lesson_5.id
        ]
      end
    end

    context 'with canceled param' do
      let(:params) { { canceled: true } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_2.id, driving_lesson_4.id, driving_lesson_6.id
        ]
      end
    end

    context 'with upcoming param' do
      let(:params) { { upcoming: true } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id, driving_lesson_2.id, driving_lesson_3.id
        ]
      end
    end

    context 'with past param' do
      let(:params) { { past: true } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_4.id, driving_lesson_5.id, driving_lesson_6.id
        ]
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    it 'returned records contain proper keys' do
      expect(json_response.first.keys).to match_array response_keys
    end

    it 'response contains driving lesson attributes' do
      expect(json_response.find { |i| i['id'] == driving_lesson_1.id }).to include(
        'id' => driving_lesson_1.id,
        # 'start_time' => driving_lesson_1.start_time.to_s,
        'employee' => {
          'id' => driving_lesson_1.employee.id,
          'name' => driving_lesson_1.employee.name,
          'surname' => driving_lesson_1.employee.surname,
        },
        'student' => {
          'id' => driving_lesson_1.student.id,
          'name' => driving_lesson_1.student.name,
          'surname' => driving_lesson_1.student.surname,
        }
      )
    end

    it 'applies default scope' do
      expect(json_response.pluck('id')).to match_array [
        driving_lesson_1.id, driving_lesson_3.id,
        driving_lesson_4.id, driving_lesson_6.id
      ]
    end

    context 'with employee_id param' do
      let(:params) { { employee_id: employee.id } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id, driving_lesson_6.id
        ]
      end
    end

    context 'with driving_lessons_ids param' do
      let(:params) { { driving_lessons_ids: [driving_lesson_1.id, driving_lesson_2.id] } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id
        ]
      end
    end

    context 'with active param' do
      let(:params) { { active: true } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id, driving_lesson_3.id
        ]
      end
    end

    context 'with canceled param' do
      let(:params) { { canceled: true } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_4.id, driving_lesson_6.id
        ]
      end
    end

    context 'with upcoming param' do
      let(:params) { { upcoming: true } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_1.id, driving_lesson_3.id
        ]
      end
    end

    context 'with past param' do
      let(:params) { { past: true } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          driving_lesson_4.id, driving_lesson_6.id
        ]
      end
    end
  end
end
