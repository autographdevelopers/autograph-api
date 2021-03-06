describe 'GET /api/v1/driving_schools/:driving_school_id/student_driving_schools/:email' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           can_manage_students: can_manage_students,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:driving_school) { create(:driving_school, status: :active) }

  let(:is_owner) { false }
  let(:can_manage_students) { false }

  before do
    get "/api/v1/driving_schools/#{driving_school_id}/student_driving_schools/#{email}/",
        headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when employee is related to driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'when employee is owner of driving school' do
        let(:is_owner) { true }

        context 'when there exist NO user record associated neither w/ invitation nor user' do
          let!(:email) { 'unexsisting@email.com' }

          it 'returns 404 http status code' do
            expect(response.status).to eq 404
          end
        end

        context 'when there exist user record associated with this student-organization' do
          let!(:student_driving_school) do
            create(:student_driving_school,
                   student: student,
                   driving_school: driving_school,
                   status: :active)
          end

          let!(:email) { student.email }

          it 'returns 200 http status code' do
            expect(response.status).to eq 200
          end
        end

        context 'when there exist invitation record associated with this student-organization' do
          let!(:invitation) { create(:invitation, invitable: invitation_student_driving_school) }
          let(:invitation_student_driving_school) do
            create(:student_driving_school,
                   student: nil,
                   driving_school: driving_school,
                   status: :pending)
          end

          let!(:email) { invitation.email }

          it 'returns 200 http status code' do
            expect(response.status).to eq 200
          end
        end
      end

      # context 'when employee can manage students' do
      #   let(:can_manage_students) { true }
      #
      #   it 'returns 200 http status code' do
      #     # expect(response.status).to eq 200
      #   end
      # end
    end
  end

  # context 'when current_user is STUDENT' do
  #   let(:current_user) { student }
  #   let(:driving_school_id) { driving_school.id }
  #
  #   it 'returns 401 http status code' do
  #     # expect(response.status).to eq 401
  #   end
  # end
end