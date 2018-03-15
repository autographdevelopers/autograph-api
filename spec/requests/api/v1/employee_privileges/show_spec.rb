describe 'GET /api/v1/driving_schools/:driving_school_id/employees/:employee_id/employee_privileges' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }
  let!(:student_driving_school) {
    create(:student_driving_school, student: student, driving_school: driving_school, status: :active)
  }
  let!(:employee_driving_school) {
    create(:employee_driving_school, is_owner: is_owner, employee: employee,
           can_manage_employees: can_manage_employees, driving_school: driving_school, status: :active)
  }
  let(:driving_school) { create(:driving_school, status: :active) }

  let(:accessed_employee) { create(:employee) }
  let!(:accessed_employee_driving_school) {
    create(:employee_driving_school, employee: accessed_employee, driving_school: driving_school, status: :active)
  }

  let(:response_keys) { %w(id can_manage_employees can_manage_students can_modify_schedules is_driving is_owner) }

  let(:is_owner) { false }
  let(:can_manage_employees) { false }

  before do
    get "/api/v1/driving_schools/#{driving_school.id}/employees/#{accessed_employee.id}/employee_privileges",
        headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when current_user is owner of driving school' do
      let(:is_owner) { true }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      context 'response body contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.keys).to match_array response_keys
        end

        it 'attributes' do
          ep = accessed_employee_driving_school.employee_privileges
          expect(subject).to include(
                               'can_manage_employees' => ep.can_manage_employees,
                               'can_manage_students' => ep.can_manage_students,
                               'can_modify_schedules' => ep.can_modify_schedules,
                               'is_driving' => ep.is_driving
                             )
        end
      end
    end

    context 'when current_user can manage employees in driving school' do
      let(:is_owner) { true }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      context 'response body contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.keys).to match_array response_keys
        end

        it 'attributes' do
          ep = accessed_employee_driving_school.employee_privileges
          expect(subject).to include(
                               'can_manage_employees' => ep.can_manage_employees,
                               'can_manage_students' => ep.can_manage_students,
                               'can_modify_schedules' => ep.can_modify_schedules,
                               'is_driving' => ep.is_driving
                             )
        end
      end
    end

    context 'when current_user is regular' do
      it 'returns 401 http status code' do
        expect(response.status).to eq 401
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end

