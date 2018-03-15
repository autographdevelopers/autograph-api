describe 'PUT /api/v1/driving_schools/driving_school_id/confirm_registration' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:student_driving_school) {
    create(:student_driving_school,
           student: student,
           driving_school: driving_school)
  }
  let!(:employee_driving_school) {
    create(:employee_driving_school,
           is_owner: is_owner,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  }

  let(:driving_school) { create(:driving_school, status: :built) }

  let(:response_keys) {
    %w[
      id name phone_numbers emails website_link additional_information
      city street country profile_picture zip_code status
    ]
  }

  before do
    put "/api/v1/driving_schools/#{driving_school_id}/confirm_registration",
        headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'when current_user is owner of driving_school' do
        let(:is_owner) { true }

        context 'when driving_school fulfilled registration requirements' do
          let(:driving_school) { create(:driving_school, :with_schedule_settings, status: :built) }

          it 'set status of driving_school to pending' do
            driving_school.reload
            expect(driving_school.status).to eq 'pending'
          end
        end

        context 'when driving_school did NOT fulfill registration requirements' do
          it 'returns 400 http status code' do
            expect(response.status).to eq 400
          end
        end
      end

      context 'when current_user is NOT owner of driving_school' do
        let(:is_owner) { false }

        it 'returns 401 http status code' do
          expect(response.status).to eq 401
        end
      end
    end

    context 'when is NOT accessing his driving school' do
      let(:driving_school_id) { create(:driving_school).id }
      let(:is_owner) { true }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }
    let(:driving_school_id) { driving_school.id }
    let(:is_owner) { false }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
