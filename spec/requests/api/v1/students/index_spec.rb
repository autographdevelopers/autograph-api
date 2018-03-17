describe 'GET /api/v1/driving_schools/:driving_school_id/students' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           can_manage_students: can_manage_students,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:invitation) { create(:invitation, invitable: invitation_student_driving_school) }
  let(:invitation_student_driving_school) do
    create(:student_driving_school,
           student: nil,
           driving_school: driving_school,
           status: :pending)
  end

  let!(:driving_lesson) do
    create(:driving_lesson,
           student_driving_school: student_driving_school,
           employee_driving_school: employee_driving_school)
  end

  let(:is_owner) { false }
  let(:can_manage_students) { false }

  let(:response_keys) do
    %w[id email name surname status type phone_number invitation_sent_at]
  end

  before do
    get "/api/v1/driving_schools/#{driving_school_id}/students",
        headers: current_user.create_new_auth_token
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when employee is related to driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'when employee is owner of driving school' do
        let(:is_owner) { true }

        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'returned records contain proper keys' do
          expect(json_response.first.keys).to match_array response_keys
        end

        it 'returns proper records' do
          expect(json_response.pluck('id')).to match_array [student.id, invitation.id]
        end

        it 'response contains student attributes' do
          expect(json_response.first).to include(
            'id' => student.id,
            'email' => student.email,
            'name' => student.name,
            'surname' => student.surname
          )
        end
      end

      context 'when employee can manage students' do
        let(:can_manage_students) { true }

        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'returned records contain proper keys' do
          expect(json_response.first.keys).to match_array response_keys
        end

        it 'returns proper records' do
          expect(json_response.pluck('id')).to match_array [student.id, invitation.id]
        end

        it 'response contains student attributes' do
          expect(json_response.first).to include(
            'id' => student.id,
            'email' => student.email,
            'name' => student.name,
            'surname' => student.surname
          )
        end
      end

      context 'when employee can NOT manage students and is NOT an owner' do
        context 'when employee had driving lesson with students' do
          it 'returns 200 http status code' do
            expect(response.status).to eq 200
          end

          it 'returned records contain proper keys' do
            expect(json_response.first.keys).to match_array response_keys
          end

          it 'returns proper records' do
            expect(json_response.pluck('id')).to match_array [student.id]
          end

          it 'response contains student attributes' do
            expect(json_response.first).to include(
              'id' => student.id,
              'email' => student.email,
              'name' => student.name,
              'surname' => student.surname
            )
          end
        end

        context 'when employee had driving lesson with students' do
          it 'returns 200 http status code' do
            expect(response.status).to eq 200
          end

          it 'returned records contain proper keys' do
            expect(json_response.first.keys).to match_array response_keys
          end

          it 'returns proper records' do
            expect(json_response.pluck('id')).to match_array [student.id]
          end

          it 'response contains student attributes' do
            expect(json_response.first).to include(
              'id' => student.id,
              'email' => student.email,
              'name' => student.name,
              'surname' => student.surname
            )
          end
        end
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }
    let(:driving_school_id) { driving_school.id }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
