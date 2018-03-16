describe 'GET /api/v1/driving_schools/:driving_school_id/employees' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           can_manage_employees: can_manage_employees,
           employee: employee,
           driving_school: driving_school,
           status: :active,
           is_driving: true)
  end

  let(:driving_school) { create(:driving_school, status: :active) }

  let(:is_owner) { false }
  let(:can_manage_employees) { false }

  let(:archived_employee) { create(:employee) }
  let!(:archived_employee_driving_school) do
    create(:employee_driving_school,
           employee: archived_employee,
           driving_school: driving_school,
           status: :archived)
  end

  let(:pending_employee) { create(:employee) }
  let!(:pending_employee_driving_school) do
    create(:employee_driving_school,
           employee: pending_employee,
           driving_school: driving_school,
           status: :pending)
  end

  let!(:invitation) do
    create(:invitation,
           invitable: invitation_employee_driving_school)
  end
  let(:invitation_employee_driving_school) do
    create(:employee_driving_school,
           employee: nil,
           driving_school: driving_school,
           status: :pending)
  end

  let(:response_keys) { %w[id email name surname status type privileges] }

  before do
    get "/api/v1/driving_schools/#{driving_school_id}/employees",
        headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when employee is related to driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'when employee is owner of driving school' do
        let(:is_owner) { true }

        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'returned records contain proper keys' do
          expect(json_response.first.keys).to match_array response_keys
        end

        it 'returns proper records' do
          expect(json_response.pluck('id')).to match_array [employee.id, pending_employee.id, invitation.id]
        end

        it 'response contains employee attributes' do
          expect(json_response.find { |i| i['id'] == employee.id }).to include(
            'id' => employee.id,
            'email' => employee.email,
            'name' => employee.name,
            'surname' => employee.surname
          )
        end
      end

      context 'when employee can manage employees' do
        let(:can_manage_employees) { true }

        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'returned records contain proper keys' do
          expect(json_response.first.keys).to match_array response_keys
        end

        it 'returns proper records' do
          expect(json_response.pluck('id')).to match_array [employee.id, pending_employee.id, invitation.id]
        end

        it 'response contains employee attributes' do
          expect(json_response.find { |i| i['id'] == employee.id }).to include(
            'id' => employee.id,
            'email' => employee.email,
            'name' => employee.name,
            'surname' => employee.surname
          )
        end
      end

      context 'when employee can NOT manage employees and is NOT an owner' do
        it 'returns 401 http status code' do
          expect(response.status).to eq 401
        end
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }
    let(:driving_school_id) { driving_school.id }

    it 'returns 200 http status code' do
      expect(response.status).to eq 200
    end

    it 'returned records contain proper keys' do
      response_keys.delete('privileges')
      expect(json_response.first.keys).to match_array response_keys
    end

    it 'returns proper records' do
      expect(json_response.pluck('id')).to match_array [employee.id]
    end

    it 'response contains employee attributes' do
      expect(json_response.first).to include(
        'id' => employee.id,
        'email' => employee.email,
        'name' => employee.name,
        'surname' => employee.surname
      )
    end
  end
end
