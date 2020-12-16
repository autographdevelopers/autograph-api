describe 'PUT /api/v1/driving_schools/:driving_school_id/custom_activity_types/:id/discard' do
  let!(:employee) { create(:employee) }

  # == School ===========================================================
  let(:driving_school) { create(:driving_school, status: :active) }

  # == School - Employee connection ===========================================================
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:name) { 'Car rental' }
  let(:message_template) { '%{user-full-name} has reported a car rental (%{item-name}).' }
  let(:target_type) { InventoryItem.name }
  let(:notification_receivers) { 'all_employees' }
  let(:datetime_input_config) { 'none' }
  let(:text_note_input_config) { 'none' }

  let!(:custom_activity_type) do
    create(:custom_activity_type,
       driving_school: driving_school,
       title: name,
       message_template: message_template,
       target_type: target_type,
       notification_receivers: notification_receivers,
       datetime_input_config: datetime_input_config,
       text_note_input_config: text_note_input_config,
     )
  end

  let(:current_user) { employee }

  let(:discard_request) do
    -> () do
      put discard_api_v1_driving_school_custom_activity_type_path(driving_school, custom_activity_type),
          headers: current_user.create_new_auth_token
    end
  end

  context 'Authorization' do
    before { discard_request.call }

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
    it 'changes discarded_at column' do
      expect { discard_request.call }.to change { CustomActivityType.discarded.count }.from(0).to(1)
    end
  end
end