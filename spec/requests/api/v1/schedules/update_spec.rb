describe 'PUT /api/v1/driving_schools/:driving_school_id/employees/:employee_id/schedule' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school)
  end
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           employee: employee,
           can_manage_employees: can_manage_employees,
           driving_school: driving_school,
           status: :active)
  end

  let(:driving_school) do
    create(:driving_school,
           :with_schedule_settings,
           status: :active)
  end

  let(:accessed_employee) { create(:employee) }
  let!(:accessed_employee_driving_school) do
    create(:employee_driving_school,
           employee: accessed_employee,
           driving_school: driving_school,
           is_driving: is_driving,
           status: :active)
  end

  let(:response_keys) do
    %w[
      id new_template_binding_from current_template
      new_template
    ]
  end

  let(:is_owner) { false }
  let(:can_manage_employees) { false }
  let(:is_driving) { true }

  let(:params) do
    {
      schedule: {
        new_template_binding_from: 2.weeks.from_now.to_date,
        current_template: {
          'monday' => (16..31).to_a,
          'tuesday' => (16..31).to_a,
          'wednesday' => (32..47).to_a,
          'thursday' => (16..31).to_a,
          'friday' => (16..31).to_a,
          'saturday' => (0..15).to_a,
          'sunday' => []
        },
        new_template: {
          'monday' => (32..47).to_a,
          'tuesday' => (32..47).to_a,
          'wednesday' => (32..47).to_a,
          'thursday' => (32..47).to_a,
          'friday' => (32..47).to_a,
          'saturday' => [],
          'sunday' => []
        }
      }
    }
  end

  before do
    put "/api/v1/driving_schools/#{driving_school.id}/employees/#{accessed_employee.id}/schedule",
        headers: current_user.create_new_auth_token, params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessed employee is driving' do
      context 'when current_user is owner of driving school' do
        let(:is_owner) { true }

        context 'when params are VALID' do
          context 'when all params sent' do
            it 'returns 200 http status code' do
              expect(response.status).to eq 200
            end

            it 'updates Schedule record' do
              schedule = accessed_employee_driving_school.schedule.reload
              expect(schedule.attributes).to include(
                'new_template_binding_from' => params[:schedule][:new_template_binding_from],
                'current_template' => params[:schedule][:current_template],
                'new_template' => params[:schedule][:new_template]
              )
            end

            it 'schedules slots' do
              expect(accessed_employee_driving_school.slots).not_to be_empty
            end

            context 'response body contains proper' do
              subject { json_response }

              it 'keys' do
                expect(subject.keys).to match_array response_keys
              end

              it 'attributes' do
                expect(subject).to include(
                  'new_template_binding_from' => params[:schedule][:new_template_binding_from].strftime('%Y-%m-%d'),
                  'current_template' => params[:schedule][:current_template],
                  'new_template' => params[:schedule][:new_template]
                )
              end
            end
          end

          context 'when only part of params sent' do
            let(:params) do
              {
                schedule: {
                  current_template: {
                    'monday' => (16..31).to_a,
                    'tuesday' => (16..31).to_a,
                    'wednesday' => (32..47).to_a,
                    'thursday' => (16..31).to_a,
                    'friday' => (16..31).to_a,
                    'saturday' => (0..15).to_a,
                    'sunday' => []
                  }
                }
              }
            end

            it 'returns 200 http status code' do
              expect(response.status).to eq 200
            end

            it 'updates Schedule record' do
              schedule = accessed_employee_driving_school.schedule.reload
              expect(schedule.attributes).to include(
                'current_template' => params[:schedule][:current_template]
              )
            end

            it 'schedules slots' do
              expect(accessed_employee_driving_school.slots).not_to be_empty
            end

            context 'response body contains proper' do
              subject { json_response }

              it 'keys' do
                expect(subject.keys).to match_array response_keys
              end

              it 'attributes' do
                expect(subject).to include(
                  'current_template' => params[:schedule][:current_template]
                )
              end
            end
          end
        end

        context 'when params are INVALID' do
          context 'when given INVALID weekdays for templates, INVALID slots ids for weekdays,' \
                'new_template_binding_from is set to past' do
            let(:params) do
              {
                schedule: {
                  new_template_binding_from: 2.weeks.ago.to_date,
                  current_template: {
                    'monday' => (16..31).to_a,
                    'invalid_tuesday' => (16..31).to_a,
                    'wednesday' => (32..47).to_a,
                    'thursday' => (16..31).to_a,
                    'friday' => (16..31).to_a,
                    'saturday' => (0..15).to_a,
                    'sunday' => []
                  },
                  new_template: {
                    'monday' => [16, 16],
                    'tuesday' => (32..47).to_a,
                    'wednesday' => (32..47).to_a,
                    'thursday' => (32..47).to_a,
                    'friday' => (32..47).to_a,
                    'saturday' => [],
                    'sunday' => []
                  }
                }
              }
            end

            it 'returns 422 http status code' do
              expect(response.status).to eq 422
            end

            it 'response contains proper error messages' do
              expect(json_response).to include(
                'new_template_binding_from' => ['must be in the future'],
                'current_template' => ['has invalid weekday(s)'],
                'new_template' => ['has invalid slot_start_times_id(s)']
              )
            end
          end
        end
      end

      context 'when current_user can manage employees in driving school' do
        let(:can_manage_employees) { true }

        context 'when params are VALID' do
          context 'when all params sent' do
            it 'returns 200 http status code' do
              expect(response.status).to eq 200
            end

            it 'updates Schedule record' do
              schedule = accessed_employee_driving_school.schedule.reload
              expect(schedule.attributes).to include(
                'new_template_binding_from' => params[:schedule][:new_template_binding_from],
                'current_template' => params[:schedule][:current_template],
                'new_template' => params[:schedule][:new_template]
              )
            end

            it 'schedules slots' do
              expect(accessed_employee_driving_school.slots).not_to be_empty
            end

            context 'response body contains proper' do
              subject { json_response }

              it 'keys' do
                expect(subject.keys).to match_array response_keys
              end

              it 'attributes' do
                expect(subject).to include(
                  'new_template_binding_from' => params[:schedule][:new_template_binding_from].strftime('%Y-%m-%d'),
                  'current_template' => params[:schedule][:current_template],
                  'new_template' => params[:schedule][:new_template]
                )
              end
            end
          end

          context 'when only part of params sent' do
            let(:params) do
              {
                schedule: {
                  current_template: {
                    'monday' => (16..31).to_a,
                    'tuesday' => (16..31).to_a,
                    'wednesday' => (32..47).to_a,
                    'thursday' => (16..31).to_a,
                    'friday' => (16..31).to_a,
                    'saturday' => (0..15).to_a,
                    'sunday' => []
                  }
                }
              }
            end

            it 'returns 200 http status code' do
              expect(response.status).to eq 200
            end

            it 'updates Schedule record' do
              schedule = accessed_employee_driving_school.schedule.reload
              expect(schedule.attributes).to include(
                'current_template' => params[:schedule][:current_template]
              )
            end

            it 'schedules slots' do
              expect(accessed_employee_driving_school.slots).not_to be_empty
            end

            context 'response body contains proper' do
              subject { json_response }

              it 'keys' do
                expect(subject.keys).to match_array response_keys
              end

              it 'attributes' do
                expect(subject).to include(
                  'current_template' => params[:schedule][:current_template]
                )
              end
            end
          end
        end

        context 'when params are INVALID' do
          context 'when given INVALID weekdays for templates, INVALID slots ids for weekdays,' \
                'new_template_binding_from is set to past' do
            let(:params) do
              {
                schedule: {
                  new_template_binding_from: 2.weeks.ago.to_date,
                  current_template: {
                    'monday' => (16..31).to_a,
                    'invalid_tuesday' => (16..31).to_a,
                    'wednesday' => (32..47).to_a,
                    'thursday' => (16..31).to_a,
                    'friday' => (16..31).to_a,
                    'saturday' => (0..15).to_a,
                    'sunday' => []
                  },
                  new_template: {
                    'monday' => [16, 16],
                    'tuesday' => (32..47).to_a,
                    'wednesday' => (32..47).to_a,
                    'thursday' => (32..47).to_a,
                    'friday' => (32..47).to_a,
                    'saturday' => [],
                    'sunday' => []
                  }
                }
              }
            end

            it 'returns 422 http status code' do
              expect(response.status).to eq 422
            end

            it 'response contains proper error messages' do
              expect(json_response).to include(
                'new_template_binding_from' => ['must be in the future'],
                'current_template' => ['has invalid weekday(s)'],
                'new_template' => ['has invalid slot_start_times_id(s)']
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
