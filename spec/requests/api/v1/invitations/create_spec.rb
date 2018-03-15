describe 'POST /api/v1/driving_schools/:driving_school_id/invitations' do
  let(:driving_school) { create(:driving_school, status: :active) }

  let(:student) { create(:student) }
  let!(:student_driving_school) {
    create(:student_driving_school, student: student, driving_school: driving_school, status: :active)
  }

  let(:employee) { create(:employee) }
  let!(:employee_driving_school) {
    create(
      :employee_driving_school,
      employee: employee,
      driving_school: driving_school,
      is_owner: is_owner,
      can_manage_employees: can_manage_employees,
      can_manage_students: can_manage_students,
      status: :active
    )
  }

  let(:is_owner) { false }
  let(:can_manage_employees) { false }
  let(:can_manage_students) { false }
  let(:invited_user_type) { User::TYPES.sample }
  let(:email) { 'test@gmail.com' }

  let(:params) do
    {
      user: {
        type: invited_user_type,
        name: 'Jon',
        surname: 'McKenzee',
        email: email
      },
      employee_privileges: {
        can_manage_employees: true,
        can_manage_students: false,
        can_modify_schedules: false,
        is_driving: true
      }
    }
  end

  subject do
    -> { post "/api/v1/driving_schools/#{driving_school_id}/invitations", headers: current_user.create_new_auth_token, params: params }
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when current_user accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'when current_user is inviting EMPLOYEE' do
        let(:invited_user_type) { User::EMPLOYEE }

        context 'when current_user has privilege to invite other employees' do
          let(:can_manage_employees) { true }

          context 'when invited user already exists' do
            let(:invited_user) { create(:employee) }
            let(:email) { invited_user.email }

            it 'returns 201 http status code' do
              subject.call

              expect(response.status).to eq 201
            end

            it 'creates EmployeeDrivingSchool record' do
              expect{ subject.call }.to change{ EmployeeDrivingSchool.count }.by 1
            end

            it 'creates EmployeePrivileges record' do
              expect{ subject.call }.to change{ EmployeePrivileges.count }.by 1
            end

            it 'creates EmployeeNotificationsSettings' do
              expect{ subject.call }.to change{ EmployeeNotificationsSettings.count }.by 1
            end

            it 'creates proper EmployeeDrivingSchool record' do
              subject.call
              expect(EmployeeDrivingSchool.last.attributes).to include(
                                                                 'employee_id' => invited_user.id,
                                                                 'driving_school_id' => driving_school.id
                                                               )
            end

            it 'creates proper EmployeePrivileges record' do
              subject.call
              expect(EmployeePrivileges.last.attributes).to include(
                                                                'employee_driving_school_id' => EmployeeDrivingSchool.last.id,
                                                                'is_owner' => false
                                                              )
            end

            it 'creates proper EmployeeNotificationsSettings' do
              subject.call
              expect(EmployeeNotificationsSettings.last.attributes).to include(
                                                                            'push_notifications_enabled' => false,
                                                                            'weekly_emails_reports_enabled' => false,
                                                                            'monthly_emails_reports_enabled' => false,
                                                                            'employee_driving_school_id' => EmployeeDrivingSchool.last.id
                                                                          )
            end

            it 'sends email about driving school requesting for cooperation' do
              expect{ subject.call }.to change { ActionMailer::Base.deliveries.count }.by(1)
            end
          end

          context 'when invited user does NOT exist' do
            it 'creates EmployeeDrivingSchool record' do
              expect{ subject.call }.to change{ EmployeeDrivingSchool.count }.by 1
            end

            it 'creates EmployeePrivileges record' do
              expect{ subject.call }.to change{ EmployeePrivileges.count }.by 1
            end

            it 'creates EmployeeNotificationsSettings' do
              expect{ subject.call }.to change{ EmployeeNotificationsSettings.count }.by 1
            end

            it 'creates Invitation' do
              expect{ subject.call }.to change{ Invitation.count }.by 1
            end

            it 'creates proper EmployeeDrivingSchool record' do
              subject.call
              expect(EmployeeDrivingSchool.last.attributes).to include(
                                                                 'employee_id' => nil,
                                                                 'driving_school_id' => driving_school.id
                                                               )
            end

            it 'creates proper EmployeePrivileges record' do
              subject.call
              expect(EmployeePrivileges.last.attributes).to include(
                                                                'employee_driving_school_id' => EmployeeDrivingSchool.last.id,
                                                                'is_owner' => false
                                                              )
            end

            it 'creates proper EmployeeNotificationsSettings' do
              subject.call
              expect(EmployeeNotificationsSettings.last.attributes).to include(
                                                                            'push_notifications_enabled' => false,
                                                                            'weekly_emails_reports_enabled' => false,
                                                                            'monthly_emails_reports_enabled' => false,
                                                                            'employee_driving_school_id' => EmployeeDrivingSchool.last.id
                                                                          )
            end

            it 'creates proper Invitation record' do
              subject.call
              expect(Invitation.last.attributes).to include(
                                           'email' => params[:user][:email],
                                           'name' => params[:user][:name],
                                           'surname' => params[:user][:surname],
                                           'invitable_type' => 'EmployeeDrivingSchool',
                                           'invitable_id' => EmployeeDrivingSchool.last.id
                                         )
            end
          end
        end

        context 'when current_user does NOT have privilege to invite other employees' do
          let(:can_manage_employees) { false }

          it 'returns 401 http status code' do
            subject.call

            expect(response.status).to eq 401
          end
        end
      end

      context 'when current_user is inviting STUDENT' do
        let(:invited_user_type) { User::STUDENT }

        context 'when current_user has privilege to invite other students' do
          let(:can_manage_students) { true }

          context 'when invited user already exists' do
            let(:invited_user) { create(:student) }
            let(:email) { invited_user.email }

            it 'creates StudentDrivingSchool record' do
              expect{ subject.call }.to change{ StudentDrivingSchool.count }.by 1
            end

            it 'creates proper StudentDrivingSchool record' do
              subject.call
              expect(StudentDrivingSchool.last.attributes).to include(
                                                                'student_id' => invited_user.id,
                                                                'driving_school_id' => driving_school.id
                                                              )
            end

            it 'sends email about driving school requesting for cooperation' do
              expect{ subject.call }.to change { ActionMailer::Base.deliveries.count }.by(1)
            end
          end

          context 'when invited user does NOT exist' do
            it 'creates Invitation' do
              expect{ subject.call }.to change{ Invitation.count }.by 1
            end

            it 'creates StudentDrivingSchool record' do
              expect{ subject.call }.to change{ StudentDrivingSchool.count }.by 1
            end

            it 'creates proper StudentDrivingSchool record' do
              subject.call
              expect(StudentDrivingSchool.last.attributes).to include(
                                                                'student_id' => nil,
                                                                'driving_school_id' => driving_school.id
                                                              )
            end

            it 'creates proper Invitation record' do
              subject.call
              expect(Invitation.last.attributes).to include(
                                                      'email' => params[:user][:email],
                                                      'name' => params[:user][:name],
                                                      'surname' => params[:user][:surname],
                                                      'invitable_type' => 'StudentDrivingSchool',
                                                      'invitable_id' => StudentDrivingSchool.last.id
                                                    )
            end
          end
        end

        context 'when current_user does NOT have privilege to invite other students' do
          let(:can_manage_students) { false }

          it 'returns 401 http status code' do
            subject.call

            expect(response.status).to eq 401
          end
        end
      end
    end

    context 'when current_user is NOT accessing his driving school' do
      let(:current_user) { employee }
      let(:driving_school_id) { create(:driving_school).id }

      it 'returns 404 http status code' do
        subject.call

        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is STUDENT accessing his driving school with some VALID params' do
    let(:current_user) { student }
    let(:driving_school_id) { driving_school.id }

    it 'returns 401 http status code' do
      subject.call

      expect(response.status).to eq 401
    end
  end
end