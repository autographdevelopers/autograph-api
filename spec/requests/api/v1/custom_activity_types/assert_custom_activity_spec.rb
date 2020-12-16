describe 'GET api/v1/driving_schools/:driving_school_id/custom_activity_types/assert_test_activity' do
  let(:employee_name) { 'Piotr' }
  let(:employee_surname) { 'Nowak' }
  let(:employee_email) { 'piotr.nowal@test.com' }

  let!(:employee) { create(:employee, name: employee_name, surname: employee_surname, email: employee_email) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:inventory_item_name) { 'Equipment#1' }
  let(:name) { 'Car rental' }
  let(:message_template) { '%{user-full-name} has reported a car rental (%{item-name}).' }
  let(:target_type) { InventoryItem.name }
  let(:notification_receivers) { :all_employees }
  let(:datetime_input_config) { :none }
  let(:text_note_input_config) { :none }

  let(:params) do
    {
      custom_activity_type: {
        title: name,
        message_template: message_template,
        target_type: target_type,
        notification_receivers: notification_receivers,
        datetime_input_config: datetime_input_config,
        text_note_input_config: text_note_input_config,
      }
    }
  end

  let(:request) do
    -> () do
      get assert_test_activity_api_v1_driving_school_custom_activity_types_path(driving_school),
          params: params,
          headers: employee.create_new_auth_token
    end
  end

  context 'Valid interpolation params' do
    context 'when Inventory Item exist' do
      let!(:inventory_item) { create(:inventory_item, driving_school: driving_school, name: inventory_item_name) }

      before { request.call }

      it 'returns 200 status' do
        expect(response).to have_http_status :ok
      end

      it 'returns test activity with proper message built' do
        expect(json_response['message']).to eq  "<b>#{employee_name} #{employee_surname}</b> has reported a car rental (<b>#{inventory_item_name}</b>)."
      end
    end

    context 'when Inventory Item does NOT exist' do
      before { request.call }

      it 'returns 200 status' do
        expect(response).to have_http_status :ok
      end

      it 'returns test activity with proper message built' do
        expect(json_response['message']).to eq  "<b>#{employee_name} #{employee_surname}</b> has reported a car rental (<b>Test Item</b>)."
      end
    end
  end

  context 'Invalid interpolation params' do
    let(:message_template) { '%{user-fullll-name} has reported a car rental (%{item-name}).' }

    let!(:inventory_item) { create(:inventory_item, driving_school: driving_school, name: inventory_item_name) }

    before { request.call }

    it 'returns 422 status' do
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'returns error message' do
      expect(json_response).to eq({'message_template' => ["Message template contains invalid key: user-fullll-name"]})
    end
  end
end
