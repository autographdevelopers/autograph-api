describe CreateInvitationService do
  let(:driving_school) { create(:driving_school) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: true,
           driving_school: driving_school)
  end

  context '#call' do
    subject do
      CreateInvitationService.new(
        driving_school,
        invited_user_type,
        invited_user_params,
        invited_user_privileges_params
      )
    end

    let(:invited_user_privileges_params) { attributes_for(:employee_privileges) }

    context 'when params are VALID' do
      context 'when invited user already exists' do
        let(:invited_user) { create(:user, type: invited_user_type) }
        let!(:invited_user_params) { invited_user.attributes.symbolize_keys.slice(:name, :surname, :email) }

        context 'when invited user is EMPLOYEE' do
          let(:invited_user_type) { User::EMPLOYEE }

          it 'creates EmployeeDrivingSchool record' do
            expect { subject.call }.to change { EmployeeDrivingSchool.count }.by 1
          end

          it 'creates EmployeePrivilege record' do
            expect { subject.call }.to change { EmployeePrivileges.count }.by 1
          end

          it 'creates EmployeeNotificationsSettings' do
            expect { subject.call }.to change { EmployeeNotificationsSettings.count }.by 1
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
            expect { subject.call }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end

        context 'when invited user is STUDENT' do
          let(:invited_user_type) { User::STUDENT }

          it 'creates StudentDrivingSchool record' do
            expect { subject.call }.to change { StudentDrivingSchool.count }.by 1
          end

          it 'creates proper StudentDrivingSchool record' do
            subject.call
            expect(StudentDrivingSchool.last.attributes).to include(
              'student_id' => invited_user.id,
              'driving_school_id' => driving_school.id
            )
          end

          it 'sends email about driving school requesting for cooperation' do
            expect { subject.call }.to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end

      context 'when invited user does NOT exist' do
        let!(:invited_user_params) do
          attributes_for(:user, type: invited_user_type)
            .slice(:name, :surname, :email)
        end

        context 'when invited user is of EMPLOYEE type' do
          let(:invited_user_type) { User::EMPLOYEE }

          it 'creates EmployeeDrivingSchool record' do
            expect { subject.call }.to change { EmployeeDrivingSchool.count }.by 1
          end

          it 'creates EmployeePrivileges record' do
            expect { subject.call }.to change { EmployeePrivileges.count }.by 1
          end

          it 'creates EmployeeNotificationsSettings' do
            expect { subject.call }.to change { EmployeeNotificationsSettings.count }.by 1
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
        end

        context 'when invited user is of STUDENT type' do
          let(:invited_user_type) { User::STUDENT }

          it 'creates StudentDrivingSchool record' do
            expect { subject.call }.to change { StudentDrivingSchool.count }.by 1
          end

          it 'creates proper StudentDrivingSchool record' do
            subject.call
            expect(StudentDrivingSchool.last.attributes).to include(
              'student_id' => nil,
              'driving_school_id' => driving_school.id
            )
          end
        end
      end
    end

    context 'when params are INVALID' do
      let(:invited_user) { create(:user) }

      it 'raises error when invited_user exists and his type does NOT match invited_user_type param' do
        invited_user_type = invited_user.type == User::EMPLOYEE ? User::STUDENT : User::EMPLOYEE
        invited_user_params = invited_user.attributes.symbolize_keys.slice(:name, :surname, :email)

        expect do
          CreateInvitationService.new(driving_school, invited_user_type, invited_user_params, invited_user_privileges_params).call
        end.to raise_error(ArgumentError, 'Invited user already exists but with different role.')
      end

      it 'raises error when invited_user does NOT exist and email is NOT passed' do
        invited_user_type = User::TYPES.sample
        invited_user_params = attributes_for(:user).symbolize_keys.slice(:name, :surname)

        expect do
          CreateInvitationService.new(driving_school, invited_user_type, invited_user_params, invited_user_privileges_params).call
        end.to raise_error ActiveRecord::RecordInvalid
      end

      it 'raises error when invited_user exists and email is NOT passed' do
        invited_user_type = invited_user.type
        invited_user_params = invited_user.attributes.symbolize_keys.slice(:name, :surname)

        expect do
          CreateInvitationService.new(driving_school, invited_user_type, invited_user_params, invited_user_privileges_params).call
        end.to raise_error ActiveRecord::RecordInvalid
      end

      it 'raises error when driving_school_id is set to nil' do
        invited_user_type = invited_user.type
        invited_user_params = invited_user.attributes.symbolize_keys.slice(:name, :surname, :email)

        expect do
          CreateInvitationService.new(nil, invited_user_type, invited_user_params, invited_user_privileges_params).call
        end.to raise_error ActiveRecord::RecordInvalid
      end

      it 'raises error when given invited_user_type is INVALID' do
        invited_user_params = invited_user.attributes.symbolize_keys.slice(:name, :surname, :email)

        expect do
          CreateInvitationService.new(driving_school, 'InvalidType', invited_user_params, invited_user_privileges_params).call
        end.to raise_error ActiveRecord::SubclassNotFound
      end
    end
  end
end
