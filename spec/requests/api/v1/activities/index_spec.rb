describe 'GET /api/v1/driving_schools/:driving_school_id/driving_lessons' do
  let(:student_1) { create(:student) }
  let(:student_2) { create(:student) }
  let(:employee_1) { create(:employee) }
  let(:employee_2) { create(:employee) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school_1) do
    create(:employee_driving_school,
           employee: employee_1,
           driving_school: driving_school,
           status: :active)
  end

  let!(:student_driving_school_1) do
    create(:student_driving_school,
           student: student_1,
           driving_school: driving_school,
           status: :active)
  end

  let!(:employee_driving_school_2) do
    create(:employee_driving_school,
           employee: employee_2,
           driving_school: driving_school,
           status: :active)
  end

  let!(:student_driving_school_2) do
    create(:student_driving_school,
           student: student_2,
           driving_school: driving_school,
           status: :active)
  end

  let(:activity_1) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: student_1,
           activity_type: :driving_lesson_scheduled)
  end

  let(:activity_2) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: employee_1,
           activity_type: :driving_lesson_scheduled)
  end

  let(:activity_3) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: student_2,
           activity_type: :driving_lesson_scheduled)
  end

  let(:activity_4) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: employee_2,
           activity_type: :driving_lesson_scheduled)
  end

  let(:activity_5) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: employee_1,
           activity_type: :driving_lesson_scheduled)
  end

  let(:activity_6) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: employee_2,
           activity_type: :driving_lesson_scheduled)
  end

  let(:params) { {} }

  let(:response_keys) do
    %w[
      id driving_school_id target_type target_id user_id activity_type
      created_at
    ]
  end

  before do
    activity_1.notifiable_users = [student_1, employee_1, student_2, employee_2]
    activity_2.notifiable_users = [student_1, employee_1, student_2]
    activity_3.notifiable_users = [student_1, employee_1]
    activity_4.notifiable_users = [student_1]
    activity_5.notifiable_users = [employee_1, employee_2]
    activity_6.notifiable_users = [employee_1, employee_2]

    get "/api/v1/driving_schools/#{driving_school.id}/activities",
        headers: current_user.create_new_auth_token,
        params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee_1 }

    it 'returned records contain proper keys' do
      expect(json_response.first.keys).to match_array response_keys
    end

    it 'response contains activity attributes' do
      expect(json_response.find { |i| i['id'] == activity_1.id }).to include(
        'driving_school_id' => activity_1.driving_school_id,
        'target_type' => activity_1.target_type,
        'target_id' => activity_1.target_id,
        'user_id' => activity_1.user_id,
        'activity_type' => activity_1.activity_type,
      )
    end

    it 'returns activities related to driving school' do
      expect(json_response.pluck('id')).to eq [
        activity_6, activity_5, activity_4, activity_3, activity_2, activity_1
      ].pluck(:id)
    end

    context 'with related_user_id param' do
      let(:params) { { related_user_id: student_1.id } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          activity_4, activity_3, activity_2, activity_1
        ].pluck(:id)
      end
    end

    context 'with maker_id param' do
      let(:params) { { maker_id: employee_2.id } }

      it 'returns proper records' do
        expect(json_response.pluck('id')).to match_array [
          activity_4, activity_6
        ].pluck(:id)
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student_1 }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
