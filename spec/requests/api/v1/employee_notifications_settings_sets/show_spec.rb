describe 'GET /api/v1/driving_schools/:driving_school_id/employee_notifications_settings_set' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }
  let!(:student_driving_school) { create(:student_driving_school, student: student, driving_school: driving_school) }
  let!(:employee_driving_school) { create(:employee_driving_school, employee: employee, driving_school: driving_school) }
  let(:driving_school) { create(:driving_school) }

  let(:response_keys) { %w(id push_notifications_enabled weekly_emails_reports_enabled monthly_emails_reports_enabled) }

  before do
    get "/api/v1/driving_schools/#{driving_school_id}/employee_notifications_settings_set", headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      context 'response body contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.keys).to match_array response_keys
        end

        it 'attributes' do
          enss = employee_driving_school.employee_notifications_settings_set
          expect(subject).to include(
                               'push_notifications_enabled' => enss.push_notifications_enabled,
                               'weekly_emails_reports_enabled' => enss.weekly_emails_reports_enabled,
                               'monthly_emails_reports_enabled' => enss.monthly_emails_reports_enabled
                             )
        end
      end
    end

    context 'when is NOT accessing his driving school' do
      let(:driving_school_id) { create(:driving_school).id }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }
    let(:driving_school_id) { driving_school.id }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end