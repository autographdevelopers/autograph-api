describe 'PUT /api/v1/driving_schools/:driving_school_id/employees/:employee_id/employee_privileges' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }
  let!(:student_driving_school) { create(:student_driving_school, student: student, driving_school: driving_school) }
  let!(:employee_driving_school) { create(:employee_driving_school, is_owner: is_owner, employee: employee,
                                          can_manage_employees: can_manage_employees, driving_school: driving_school) }
  let(:driving_school) { create(:driving_school) }

  let(:accessed_employee) { create(:employee) }
  let!(:accessed_employee_driving_school) { create(:employee_driving_school, employee: accessed_employee, driving_school: driving_school) }

  let(:response_keys) { %w(id can_manage_employees can_manage_students can_modify_schedules is_driving is_owner) }

  let(:is_owner) { false }
  let(:can_manage_employees) { false }

  let(:params) do
    {
      employee_privileges: {
        can_manage_employees: false,
        can_manage_students: true,
        can_modify_schedules: true,
        is_driving: false
      }
    }
  end

  before do
    put "/api/v1/driving_schools/#{driving_school.id}/employees/#{accessed_employee.id}/employee_privileges",
        headers: current_user.create_new_auth_token, params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when current_user is owner of driving school' do
      let(:is_owner) { true }

      context 'when params are VALID' do
        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'updates EmployeePrivileges record' do
          employee_privileges = accessed_employee_driving_school.employee_privileges.reload
          expect(employee_privileges.attributes).to include(
                                                         'can_manage_employees' => params[:employee_privileges][:can_manage_employees],
                                                         'can_manage_students' => params[:employee_privileges][:can_manage_students],
                                                         'can_modify_schedules' => params[:employee_privileges][:can_modify_schedules],
                                                         'is_driving' => params[:employee_privileges][:is_driving]
                                                       )
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            expect(subject).to include(
                                 'can_manage_employees' => params[:employee_privileges][:can_manage_employees],
                                 'can_manage_students' => params[:employee_privileges][:can_manage_students],
                                 'can_modify_schedules' => params[:employee_privileges][:can_modify_schedules],
                                 'is_driving' => params[:employee_privileges][:is_driving]
                               )
          end
        end
      end

      context 'when params are INVALID' do
        context 'all fields blank' do
          let(:params) do
            {
              employee_privileges: {
                can_manage_employees: '',
                can_manage_students: '',
                can_modify_schedules: '',
                is_driving: ''
              }
            }
          end

          it 'returns 422 http status code' do
            expect(response.status).to eq 422
          end

          it 'response contains proper error messages' do
            expect(json_response).to include(
                                       'can_manage_employees' => ['is not included in the list'],
                                       'can_manage_students' => ['is not included in the list'],
                                       'can_modify_schedules' => ['is not included in the list'],
                                       'is_driving' => ['is not included in the list']
                                     )
          end
        end
      end
    end

    context 'when current_user can manage employees in driving school' do
      let(:can_manage_employees) { true }

      context 'when params are VALID' do
        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'updates EmployeePrivilege record' do
          employee_privileges = accessed_employee_driving_school.employee_privileges.reload
          expect(employee_privileges.attributes).to include(
                                                         'can_manage_employees' => params[:employee_privileges][:can_manage_employees],
                                                         'can_manage_students' => params[:employee_privileges][:can_manage_students],
                                                         'can_modify_schedules' => params[:employee_privileges][:can_modify_schedules],
                                                         'is_driving' => params[:employee_privileges][:is_driving]
                                                       )
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            expect(subject).to include(
                                 'can_manage_employees' => params[:employee_privileges][:can_manage_employees],
                                 'can_manage_students' => params[:employee_privileges][:can_manage_students],
                                 'can_modify_schedules' => params[:employee_privileges][:can_modify_schedules],
                                 'is_driving' => params[:employee_privileges][:is_driving]
                               )
          end
        end
      end

      context 'when params are INVALID' do
        context 'all fields blank' do
          let(:params) do
            {
              employee_privileges: {
                can_manage_employees: '',
                can_manage_students: '',
                can_modify_schedules: '',
                is_driving: ''
              }
            }
          end

          it 'returns 422 http status code' do
            expect(response.status).to eq 422
          end

          it 'response contains proper error messages' do
            expect(json_response).to include(
                                       'can_manage_employees' => ['is not included in the list'],
                                       'can_manage_students' => ['is not included in the list'],
                                       'can_modify_schedules' => ['is not included in the list'],
                                       'is_driving' => ['is not included in the list']
                                     )
          end
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
