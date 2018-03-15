describe 'PUT /api/v1/driving_schools/:driving_school_id/invitations/reject' do
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
    put "/api/v1/driving_schools/#{driving_school_id}/invitations/reject",
      headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when current_user has pending invitation' do
      let(:status) { :pending }

      it 'returns 204 http status code' do
        expect(response.status).to eq 204
      end

      it 'changes relation status from pending to rejected' do
        employee_driving_school.reload
        expect(employee_driving_school.status).to eq 'rejected'
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

      it 'returns 204 http status code' do
        expect(response.status).to eq 204
      end

      it 'changes relation status from pending to rejected' do
        student_driving_school.reload
        expect(student_driving_school.status).to eq 'rejected'
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
