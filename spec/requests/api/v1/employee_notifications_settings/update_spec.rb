describe 'PUT /api/v1/driving_schools/:driving_school_id/employee_notifications_settings' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school)
  end
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           is_owner: true)
  end

  let(:driving_school) { create(:driving_school) }

  let(:response_keys) do
    %w[
      id push_notifications_enabled weekly_emails_reports_enabled
      monthly_emails_reports_enabled
    ]
  end

  let(:valid_params) do
    {
      employee_notifications_settings: {
        push_notifications_enabled: true,
        weekly_emails_reports_enabled: true,
        monthly_emails_reports_enabled: false
      }
    }
  end

  before do
    put "/api/v1/driving_schools/#{driving_school_id}/employee_notifications_settings",
        headers: current_user.create_new_auth_token, params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'with VALID params' do
        let(:params) { valid_params }

        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'updates EmployeeNotificationsSettings record' do
          employee_notifications_settings = employee_driving_school.employee_notifications_settings
          employee_notifications_settings.reload
          expect(employee_notifications_settings.attributes).to include(
            'push_notifications_enabled' => true,
            'weekly_emails_reports_enabled' => true,
            'monthly_emails_reports_enabled' => false
          )
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            expect(subject).to include(
              'push_notifications_enabled' => true,
              'weekly_emails_reports_enabled' => true,
              'monthly_emails_reports_enabled' => false
            )
          end
        end
      end

      context 'with INVALID params' do
        context 'all fields blank' do
          let(:params) do
            {
              employee_notifications_settings: {
                push_notifications_enabled: '',
                weekly_emails_reports_enabled: '',
                monthly_emails_reports_enabled: ''
              }
            }
          end

          it 'returns 422 http status code' do
            expect(response.status).to eq 422
          end

          it 'response contains proper error messages' do
            expect(json_response).to include(
              'push_notifications_enabled' => ['is not included in the list'],
              'weekly_emails_reports_enabled' => ['is not included in the list'],
              'monthly_emails_reports_enabled' => ['is not included in the list']
            )
          end
        end
      end
    end

    context 'with VALID params BUT is NOT accessing his driving school ' do
      let(:driving_school_id) { create(:driving_school).id }
      let(:params) { valid_params }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is STUDENT and accessing his driving school with VALID params' do
    let(:current_user) { student }
    let(:driving_school_id) { driving_school.id }
    let(:params) { valid_params }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
