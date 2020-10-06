describe 'PUT /api/v1/driving_schools/:driving_school_id/students/:student_id/driving_courses/:id' do
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
           employee: employee,
           can_manage_students: can_manage_students,
           driving_school: driving_school,
           status: :active)
  end

  let(:driving_course) { student_driving_school.driving_courses.first }

  let(:driving_school) { create(:driving_school, status: :active) }

  let(:response_keys) do
    %w[
      id available_hours booked_hours used_hours category_type
    ]
  end

  let(:is_owner) { false }
  let(:can_manage_students) { false }

  let(:params) do
    {
      driving_course: {
        available_hours: 21.5
      }
    }
  end

  before do
    put "/api/v1/driving_schools/#{driving_school.id}/students/#{student.id}/driving_courses/#{driving_course.id}",
        headers: current_user.create_new_auth_token,
        params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when current_user is owner of driving school' do
      let(:is_owner) { true }

      context 'when params are VALID' do
        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'updates DrivingCourse record' do
          driving_course.reload
          expect(driving_course.attributes).to include(
            'available_hours' => params[:driving_course][:available_hours]
          )
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            expect(subject).to include(
              'available_hours' => params[:driving_course][:available_hours].to_s
            )
          end
        end
      end

      context 'when params are INVALID' do
        context 'all fields blank' do
          let(:params) do
            {
              driving_course: {
                available_hours: ''
              }
            }
          end

          it 'returns 422 http status code' do
            expect(response.status).to eq 422
          end

          it 'response contains proper error messages' do
            expect(json_response).to include(
              'available_hours' => ["can't be blank", 'is not a number']
            )
          end
        end
      end
    end

    context 'when current_user can manage employees in driving school' do
      let(:can_manage_students) { true }

      context 'when params are VALID' do
        it 'returns 200 http status code' do
          expect(response.status).to eq 200
        end

        it 'updates DrivingCourse record' do
          driving_course.reload
          expect(driving_course.attributes).to include(
            'available_hours' => params[:driving_course][:available_hours]
          )
        end

        context 'response body contains proper' do
          subject { json_response }

          it 'keys' do
            expect(subject.keys).to match_array response_keys
          end

          it 'attributes' do
            expect(subject).to include(
              'available_hours' => params[:driving_course][:available_hours].to_s
            )
          end
        end
      end

      context 'when params are INVALID' do
        context 'all fields blank' do
          let(:params) do
            {
              driving_course: {
                available_hours: ''
              }
            }
          end

          it 'returns 422 http status code' do
            expect(response.status).to eq 422
          end

          it 'response contains proper error messages' do
            expect(json_response).to include(
              'available_hours' => ["can't be blank", 'is not a number']
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
