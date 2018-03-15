describe 'GET /api/v1/driving_schools/:driving_school_id/employees/:employee_id/schedule' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }
  let!(:student_driving_school) { create(:student_driving_school, student: student, driving_school: driving_school, status: :active) }
  let!(:employee_driving_school) {
    create(:employee_driving_school, is_owner: is_owner, employee: employee,
           can_manage_employees: can_manage_employees, driving_school: driving_school, status: :active)
  }
  let(:driving_school) { create(:driving_school, :with_schedule_settings, status: :active) }

  let(:accessed_employee) { create(:employee) }
  let!(:accessed_employee_driving_school) { create(:employee_driving_school, employee: accessed_employee,
                                                   driving_school: driving_school, is_driving: is_driving, status: :active) }

  let(:response_keys) { %w(id repetition_period_in_weeks new_template_binding_from current_template new_template) }

  let(:is_owner) { false }
  let(:can_manage_employees) { false }
  let(:is_driving) { true }

  before do
    accessed_employee_driving_school.schedule.update!(attributes_for(:schedule))
    get "/api/v1/driving_schools/#{driving_school.id}/employees/#{accessed_employee.id}/schedule", headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessed employee is driving' do
      context 'when current_user is owner of driving school' do
        let(:is_owner) { true }

        context 'when params are VALID' do
          it 'returns 200 http status code' do
            expect(response.status).to eq 200
          end

          context 'response body contains proper' do
            subject { json_response }

            it 'keys' do
              expect(subject.keys).to match_array response_keys
            end

            it 'attributes' do
              schedule = accessed_employee_driving_school.schedule
              expect(subject).to include(
                                   'repetition_period_in_weeks' => schedule.repetition_period_in_weeks,
                                   'new_template_binding_from' => schedule.new_template_binding_from.strftime('%Y-%m-%d'),
                                   'current_template' => schedule.current_template,
                                   'new_template' => schedule.new_template
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

          context 'response body contains proper' do
            subject { json_response }

            it 'keys' do
              expect(subject.keys).to match_array response_keys
            end

            it 'attributes' do
              schedule = accessed_employee_driving_school.schedule
              expect(subject).to include(
                                   'repetition_period_in_weeks' => schedule.repetition_period_in_weeks,
                                   'new_template_binding_from' => schedule.new_template_binding_from.strftime('%Y-%m-%d'),
                                   'current_template' => schedule.current_template,
                                   'new_template' => schedule.new_template
                                 )
            end
          end
        end
      end
    end

    context 'when accessed employee is not driving' do
      it 'returns 401 http status code' do
        expect(response.status).to eq 401
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
