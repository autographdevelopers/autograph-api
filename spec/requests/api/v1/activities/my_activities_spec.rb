describe 'GET /api/v1/driving_schools/:driving_school_id/driving_lessons' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end

  let(:activity_1) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: student,
           activity_type: :driving_lesson_scheduled)
  end

  let(:activity_2) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: employee,
           activity_type: :driving_lesson_scheduled)
  end

  let(:activity_3) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: student,
           activity_type: :driving_lesson_scheduled)
  end

  let(:activity_4) do
    create(:activity,
           driving_school: driving_school,
           target: create(:driving_lesson),
           user: employee,
           activity_type: :driving_lesson_scheduled)
  end

  let(:params) { {} }

  let(:response_keys) do
    %w[
      id driving_school_id target_type target_id user_id activity_type
      created_at read message
    ]
  end

  before do
    activity_1.notifiable_users = [student, employee]
    activity_2.notifiable_users = [student, employee]
    activity_3.notifiable_users = [employee]
    activity_4.notifiable_users = [student]

    get "/api/v1/driving_schools/#{driving_school.id}/activities/my_activities",
        headers: current_user.create_new_auth_token,
        params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

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
        'read' => false,
        'message' => kind_of(String)
      )
    end

    it 'returns activities related to current_user' do
      expect(json_response.pluck('id')).to eq [
        activity_3, activity_2, activity_1
      ].pluck(:id)
    end

    it 'sets fetched UserActivities read to true' do
      notifiable_user_activities = NotifiableUserActivity.where(user_id: current_user.id)
      expect(notifiable_user_activities.pluck(:read)).to all(be true)
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

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
        'read' => false,
        'message' => kind_of(String)
      )
    end

    it 'returns activities related to current_user' do
      expect(json_response.pluck('id')).to eq [
        activity_4, activity_2, activity_1
      ].pluck(:id)
    end

    it 'sets fetched UserActivities read to true' do
      notifiable_user_activities = NotifiableUserActivity.where(user_id: current_user.id)
      expect(notifiable_user_activities.pluck(:read)).to all(be true)
    end
  end
end
