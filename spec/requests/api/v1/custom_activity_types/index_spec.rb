describe 'GET /api/v1/driving_schools/:driving_school_id/custom_activity_types' do
  let!(:employee) { create(:employee) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let!(:custom_activity_types) do
    create_list(:custom_activity_type, 5,
           driving_school: driving_school,
           name: 'Test Report',
           message_template: 'Test Report has been reported by ${user-full-name}',
           target_type: nil,
           notification_receivers: 'all_employees',
           datetime_input_config: 'none',
           text_note_input_config: 'none',
           )
  end

  let!(:discarded_custom_activity_types) do
    create_list(:custom_activity_type, 5,
                driving_school: driving_school,
                name: 'Test Report',
                message_template: 'Test Report has been reported by ${user-full-name}',
                target_type: nil,
                notification_receivers: 'all_employees',
                datetime_input_config: 'none',
                text_note_input_config: 'none',
                discarded_at: Time.current,
                )
  end

  let(:current_user) { employee }

  let(:index_request) do
    -> () do
      get api_v1_driving_school_custom_activity_types_path(driving_school), headers: current_user.create_new_auth_token
    end
  end

  context 'Authorization' do
    before { index_request.call }

    context 'when is an Employee' do
      let(:current_user) { employee }

      it 'returns success status' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when is an Employee but from other org' do
      let(:current_user) { create(:employee) }

      it 'returns success status' do
        expect(response).to have_http_status :not_found
      end
    end

    context 'when is a Student' do
      let!(:student) { create(:student) }

      let!(:student_driving_school) do
        create(:student_driving_school,
               student: student,
               driving_school: driving_school,
               status: :active)
      end

      let(:current_user) { student }

      it 'returns success status' do
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  context 'DB changes' do
    before { index_request.call }

    it 'returns not discarded records' do
      expect(json_response.pluck('id')).to contain_exactly *custom_activity_types.pluck(:id)
    end
  end
end
