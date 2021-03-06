describe 'PUT /api/v1/driving_schools/:driving_school_id/invitations/accept' do
  let(:driving_school) { create(:driving_school) }
  let(:driving_school_id) { driving_school.id }

  let(:student) { create(:student) }
  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: status)
  end

  let(:employee) { create(:employee) }
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: status)
  end

  before do
    put "/api/v1/driving_schools/#{driving_school_id}/invitations/accept",
        headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when current_user has pending invitation' do
      let(:status) { :pending }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      it 'creates Activity record' do
        expect(Activity.count).to eq 1
      end

      it 'creates proper Activity record' do
        expect(Activity.last.attributes).to include(
          'target_id' => employee_driving_school.id,
          'target_type' => 'EmployeeDrivingSchool',
          'activity_type' => 'employee_invitation_accepted',
          'user_id' => current_user.id,
          'driving_school_id' => driving_school_id,
        )
      end

      it 'changes relation status from pending to active' do
        employee_driving_school.reload
        expect(employee_driving_school.status).to eq 'active'
      end
    end

    context 'when current_user has active relation with driving school' do
      let(:status) { :active }

      it 'returns 400 http status code' do
        expect(response.status).to eq 400
      end
    end

    context 'when current_user has no relation with driving school' do
      let(:current_user) { create(:employee) }
      let(:status) { :pending }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    context 'when current_user has pending invitation' do
      let(:status) { :pending }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      it 'creates Activity record' do
        expect(Activity.count).to eq 1
      end

      it 'creates proper Activity record' do
        expect(Activity.last.attributes).to include(
          'target_id' => student_driving_school.id,
          'target_type' => 'StudentDrivingSchool',
          'activity_type' => 'student_invitation_accepted',
          'user_id' => current_user.id,
          'driving_school_id' => driving_school_id,
        )
      end

      it 'changes relation status from pending to active' do
        student_driving_school.reload
        expect(student_driving_school.status).to eq 'active'
      end
    end

    context 'when current_user has active relation with driving school' do
      let(:status) { :active }

      it 'returns 400 http status code' do
        expect(response.status).to eq 400
      end
    end

    context 'when current_user has no relation with driving school' do
      let(:current_user) { create(:employee) }
      let(:status) { :pending }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end
end
