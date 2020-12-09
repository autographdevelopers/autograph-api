describe 'POST /api/v1/driving_schools/:driving_school_id/activities' do
  let!(:employee) { create(:employee, name: 'John', surname: 'Doe') }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:message_template) { target_type ? '%{user-full-name} reported %{item-name} usage' : '%{user-full-name} reported some event' }
  let(:datetime_input_config) { :none }
  let(:text_note_input_config) { :none }
  let(:target_type) { nil }

  let(:custom_activity_type) {
    create(:custom_activity_type,
           message_template: message_template,
           datetime_input_config: datetime_input_config,
           text_note_input_config: text_note_input_config,
           target_type: target_type
    )
  }

  let(:inventory_item) { nil }
  let(:target_id) { inventory_item ? inventory_item.id : nil }
  let(:note) { 'test desc' }
  let(:date) { Time.current }

  let(:params) do
    {
      activity: {
        custom_activity_type_id: custom_activity_type.id,
        target_type: target_type,
        target_id: target_id,
        note: note,
        date: date
      }
    }
  end

  let!(:create_request) do
    -> do
      post api_v1_driving_school_activities_path(driving_school),
           params: params,
           headers: employee.create_new_auth_token
    end
  end

  context 'when custom event type require target' do
    let(:target_type) { InventoryItem.name }
    context 'when is provided' do
      let(:inventory_item) { create(:inventory_item, name: 'car') }

      it 'saves 1 Activity record' do
        expect { create_request.call }.to change {
          Activity.count
        }.from(0).to(1)
      end

      it 'saves the record with expected msg' do
        expect { create_request.call }.to change {
          Activity.last&.message
        }.from(nil).to('<b>John Doe</b> reported <b>car</b> usage')
      end

      it 'returns 200 status code' do
        create_request.call
        expect(response).to have_http_status :ok
      end
    end

    context 'when is NOT provided' do
      let(:inventory_item) { nil }

      it 'saves 1 Activity record' do
        expect { create_request.call }.not_to change { Activity.count }
      end

      it 'saves the record with expected msg' do
        expect { create_request.call }.not_to change { Activity.last&.message }
      end

      it 'returns 422 status code' do
        create_request.call
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  context 'when custom event type does NOT configure target' do
    context 'when is NOT provided' do
      let(:target_type) { nil }
      let(:message_template) { '%{user-full-name} reported some event' }

      it 'saves 1 Activity record' do
        expect { create_request.call }.to change {
          Activity.count
        }.from(0).to(1)
      end

      it 'saves the record with expected msg' do
        expect { create_request.call }.to change {
          Activity.last&.message
        }.from(nil).to('<b>John Doe</b> reported some event')
      end

      it 'returns 200 status code' do
        create_request.call
        expect(response).to have_http_status :ok
      end
    end
  end

  context 'when datetime input' do
    context 'is required' do
      let(:datetime_input_config) { :required }
      context 'when it is provided' do
        let(:date) { Time.current }

        it 'saves 1 Activity record' do
          expect { create_request.call }.to change {
            Activity.count
          }.from(0).to(1)
        end

        it 'returns 200 status code' do
          create_request.call
          expect(response).to have_http_status :ok
        end
      end

      context 'when it is NOT provided' do
        let(:date) { nil }

        it 'does NOT save 1 Activity record' do
          expect { create_request.call }.not_to change { Activity.count }
        end

        it 'returns 422 status code' do
          create_request.call
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'is optional' do
      let(:datetime_input_config) { :optional }
      context 'when it is provided' do
        let(:date) { Time.current }

        it 'saves 1 Activity record' do
          expect { create_request.call }.to change {
            Activity.count
          }.from(0).to(1)
        end

        it 'returns 200 status code' do
          create_request.call
          expect(response).to have_http_status :ok
        end
      end

      context 'when it is NOT provided' do
        let(:date) { nil }

        it 'saves 1 Activity record' do
          expect { create_request.call }.to change {
            Activity.count
          }.from(0).to(1)
        end

        it 'returns 200 status code' do
          create_request.call
          expect(response).to have_http_status :ok
        end
      end
    end
  end

  context 'when text_note input' do
    context 'is required' do
      let(:text_note_input_config) { :required }
      context 'when it is provided' do
        let(:note) { 'test' }

        it 'saves 1 Activity record' do
          expect { create_request.call }.to change {
            Activity.count
          }.from(0).to(1)
        end

        it 'returns 200 status code' do
          create_request.call
          expect(response).to have_http_status :ok
        end
      end

      context 'when it is NOT provided' do
        let(:note) { nil }

        it 'does NOT save 1 Activity record' do
          expect { create_request.call }.not_to change { Activity.count }
        end

        it 'returns 422 status code' do
          create_request.call
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context 'is optional' do
      let(:datetime_input_config) { :optional }
      context 'when it is provided' do
        let(:note) { 'test' }

        it 'saves 1 Activity record' do
          expect { create_request.call }.to change { Activity.count }.from(0).to(1)
        end

        it 'returns 200 status code' do
          create_request.call
          expect(response).to have_http_status :ok
        end
      end

      context 'when it is NOT provided' do
        let(:note) { nil }

        it 'saves 1 Activity record' do
          expect { create_request.call }.to change { Activity.count }.from(0).to(1)
        end

        it 'returns 200 status code' do
          create_request.call
          expect(response).to have_http_status :ok
        end
      end
    end
  end
end
