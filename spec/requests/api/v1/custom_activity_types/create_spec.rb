describe 'POST /api/v1/driving_schools/:driving_school_id/custom_activity_types' do
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

  let(:response_keys) do
    %w[
      title
      message_template
      target_type
      notification_receivers
      datetime_input_config
      text_note_input_config
    ]
  end

  let(:attrs_slice) do
    {
      'title' => name,
      'message_template' => message_template,
      'target_type' => target_type,
      'notification_receivers' => notification_receivers,
      'datetime_input_config' => datetime_input_config,
      'text_note_input_config' => text_note_input_config
    }
  end

  # == Request ===========================================================
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

  let(:current_user) { employee }

  let(:create_request) do
    -> () do
      post api_v1_driving_school_custom_activity_types_path(driving_school),
          params: params,
          headers: current_user.create_new_auth_token
    end
  end

  context 'Authorization' do
    before { create_request.call }

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
        it 'creates 1 Activity record' do
          expect { create_request.call }.to change { CustomActivityType.count }.from(0).to(1)
        end

        it 'creates Activity record with expected params' do
          expect { create_request.call }.to change {
            CustomActivityType.last&.slice(*response_keys)
          }.from(nil).to(attrs_slice)
        end
      end

      context 'HTTP response' do
        before { create_request.call }

        it 'returns 200 status code' do
          expect(response).to have_http_status :ok
        end

        it 'returns proper JSON response' do
          expect(json_response.slice(*response_keys)).to eq attrs_slice
        end
      end
    end

    context 'Without target_type' do
      let(:target_type) { nil }
      let(:message_template) { '%{user-full-name} has reported a car rental.' }

      context 'BD changes' do
        it 'creates 1 Activity record' do
          expect { create_request.call }.to change { CustomActivityType.count }.from(0).to(1)
        end

        it 'creates Activity record with expected params' do
          expect { create_request.call }.to change {
            CustomActivityType.last&.slice(*response_keys)
          }.from(nil).to(attrs_slice)
        end
      end

      context 'HTTP response' do
        before { create_request.call }

        it 'returns 200 status code' do
          expect(response).to have_http_status :ok
        end

        it 'returns proper JSON response' do
          expect(json_response.slice(*response_keys)).to eq attrs_slice
        end
      end
    end
  end

  context 'Invalid params' do
    context 'message_template contains invalid key' do
      let(:message_template) { 'Blabla %{invalid-unknown-key}' }

      context 'BD changes' do
        it 'does NOT create Activity record' do
          expect { create_request.call }.not_to change { CustomActivityType.count }
        end
      end

      context 'HTTP response' do
        before { create_request.call }

        it 'returns 422 status code' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns proper JSON response' do
          expect(json_response).to eq('message_template' => ["Message template contains invalid key: invalid-unknown-key"])
        end
      end
    end

    context 'message_template in blank' do
      let(:message_template) { nil }

      context 'BD changes' do
        it 'does NOT create Activity record' do
          expect { create_request.call }.not_to change { CustomActivityType.count }
        end
      end

      context 'HTTP response' do
        before { create_request.call }

        it 'returns 422 status code' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns proper JSON response' do
          expect(json_response).to eq('message_template' => ["can't be blank"])
        end
      end
    end

    context 'name in blank' do
      let(:name) { nil }

      context 'BD changes' do
        it 'does NOT create Activity record' do
          expect { create_request.call }.not_to change { CustomActivityType.count }
        end
      end

      context 'HTTP response' do
        before { create_request.call }

        it 'returns 422 status code' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns proper JSON response' do
          expect(json_response).to eq('title' => ["can't be blank"])
        end
      end
    end

    context 'notification_receivers in blank' do
      let(:notification_receivers) { nil }

      context 'BD changes' do
        it 'does NOT create Activity record' do
          expect { create_request.call }.not_to change { CustomActivityType.count }
        end
      end

      context 'HTTP response' do
        before { create_request.call }

        it 'returns 422 status code' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns proper JSON response' do
          expect(json_response).to eq('notification_receivers' => ["can't be blank"])
        end
      end
    end

    context 'datetime_input_config in blank' do
      let(:datetime_input_config) { nil }

      context 'BD changes' do
        it 'does NOT create Activity record' do
          expect { create_request.call }.not_to change { CustomActivityType.count }
        end
      end

      context 'HTTP response' do
        before { create_request.call }

        it 'returns 422 status code' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns proper JSON response' do
          expect(json_response).to eq('datetime_input_config' => ["can't be blank"])
        end
      end
    end

    context 'text_note_input_config in blank' do
      let(:text_note_input_config) { nil }

      context 'BD changes' do
        it 'does NOT create Activity record' do
          expect { create_request.call }.not_to change { CustomActivityType.count }
        end
      end

      context 'HTTP response' do
        before { create_request.call }

        it 'returns 422 status code' do
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'returns proper JSON response' do
          expect(json_response).to eq('text_note_input_config' => ["can't be blank"])
        end
      end
    end
  end
end