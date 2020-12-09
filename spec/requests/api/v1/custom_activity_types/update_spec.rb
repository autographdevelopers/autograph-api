describe 'PUT /api/v1/driving_schools/:driving_school_id/custom_activity_types/:id' do
  # == Employee ===========================================================
  let(:employee_name) { 'Piotr' }
  let(:employee_surname) { 'Nowak' }
  let(:employee_email) { 'piotr.nowal@test.com' }
  let!(:employee) { create(:employee, name: employee_name, surname: employee_surname, email: employee_email) }

  # == School ===========================================================
  let(:driving_school) { create(:driving_school, status: :active) }

  # == School - Employee connection ===========================================================
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  # == Custom activity type ===========================================================
  let(:name) { 'Car rental' }
  let(:message_template) { '%{user-full-name} has reported a car rental (%{item-name}).' }
  let(:target_type) { InventoryItem.name }
  let(:notification_receivers) { 'all_employees' }
  let(:datetime_input_config) { 'none' }
  let(:text_note_input_config) { 'none' }

  let!(:custom_activity_type) do
    create(:custom_activity_type,
      driving_school: driving_school,
      name: name,
      message_template: message_template,
      target_type: target_type,
      notification_receivers: notification_receivers,
      datetime_input_config: datetime_input_config,
      text_note_input_config: text_note_input_config,
    )
  end

  let(:create_attrs_slice) do
    {
      'name' => name,
      'message_template' => message_template,
      'target_type' => target_type,
      'notification_receivers' => notification_receivers,
      'datetime_input_config' => datetime_input_config,
      'text_note_input_config' => text_note_input_config
    }
  end

  let(:response_keys) do
    %w[
      name
      message_template
      target_type
      notification_receivers
      datetime_input_config
      text_note_input_config
    ]
  end

  let(:updated_attrs_slice) do
    {
      'name' => update_params[:custom_activity_type][:name],
      'message_template' => update_params[:custom_activity_type][:message_template],
      'target_type' => update_params[:custom_activity_type][:target_type],
      'notification_receivers' => update_params[:custom_activity_type][:notification_receivers],
      'datetime_input_config' => update_params[:custom_activity_type][:datetime_input_config],
      'text_note_input_config' => update_params[:custom_activity_type][:text_note_input_config]
    }
  end

  # == Request ===========================================================
  let(:message_template_update_val) { '%{user-full-name} has reported a car rental.' }
  let(:name_update_val) { name+ '-updated' }
  let(:update_params) do
    {
      custom_activity_type: {
        name: name_update_val,
        message_template: message_template_update_val,
        target_type: nil,
        datetime_input_config: 'required',
        text_note_input_config: 'optional',
        notification_receivers: 'all_employees',
      }
    }
  end

  let(:current_user) { employee }

  let(:update_request) do
    -> () do
      put api_v1_driving_school_custom_activity_type_path(driving_school, custom_activity_type),
          params: update_params,
          headers: current_user.create_new_auth_token
    end
  end

  context 'Authorization' do
    before { update_request.call }

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

  context 'Valid params' do
    context 'All attributes provided' do
      context 'BD changes' do
        it 'updates CustomActivityType record with expected params' do
          expect { update_request.call }.to change {
            CustomActivityType.last&.slice(*response_keys)
          }.from(create_attrs_slice).to(updated_attrs_slice)
        end
      end

      context 'HTTP response' do
        before { update_request.call }

        it 'returns 200 status code' do
          expect(response).to have_http_status :ok
        end

        it 'returns proper JSON response' do
          expect(json_response.slice(*response_keys)).to eq updated_attrs_slice
        end
      end
    end
  end

  context 'Invalid params' do
    context 'message_template contains invalid key' do
      let(:message_template_update_val) { 'Blabla %{invalid-unknown-key}' }

      context 'BD changes' do
        it 'does NOT create Activity record' do
          expect { update_request.call }.not_to change { CustomActivityType.last&.slice(*response_keys) }
        end
      end

      context 'HTTP response' do
        before { update_request.call }

        it 'returns 422 status code' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns proper JSON response' do
          expect(json_response).to eq('message_template' => ["Message template contains invalid key: invalid-unknown-key"])
        end
      end
    end

    context 'message_template in blank' do
      let(:name_update_val) { nil }

      context 'BD changes' do
        it 'does NOT create Activity record' do
          expect { update_request.call }.not_to change { CustomActivityType.last&.slice(*response_keys) }
        end
      end

      context 'HTTP response' do
        before { update_request.call }

        it 'returns 422 status code' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns proper JSON response' do
          expect(json_response).to eq('name' => ["can't be blank"])
        end
      end
    end
  end
end