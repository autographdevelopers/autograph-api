describe 'POST /api/v1/driving_schools/:driving_school_id/courses' do
  let(:employee) { create(:employee) }
  let(:student) { create(:student) }
  let(:driving_school) { create(:driving_school, status: :active) }
  let(:is_owner) { true }
  let(:course_type) { create(:course_type, driving_school: driving_school) }

  let(:name) { 'Test name' }
  let(:description) { 'Test description' }
  let(:course_participations_limit) { nil }
  let(:course_type_id) { course_type.id }

  let(:params) {
    {
      course: {
        name: name,
        description: description,
        course_participations_limit: course_participations_limit,
        course_type_id: course_type_id
      }
    }
  }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end

  let(:current_user) { employee }

  let(:create_request) do
    -> { post api_v1_driving_school_courses_path(driving_school), headers: current_user.create_new_auth_token, params: params }
  end

  context 'with proper params' do
    it 'creates new course record' do
      expect { create_request.call }.to change { Course.count }.from(0).to(1)
    end

    it 'returns proper http status' do
      create_request.call
      expect(response).to have_http_status :ok
    end

    it 'returns proper http response body' do
      create_request.call
      expect(json_response).to eq(
        {
           "id" => Course.last.id,
           "name" => "Test name",
           "description" => "Test description",
           "status" => "active",
           "start_time" => nil,
           "end_time" => nil,
           "driving_school_id" => driving_school.id,
           "course_type" => {
               "id" => course_type.id,
               "name" => "Test Course",
               "description" => "Test Description",
               "status" => "active"
           }
        }
      )
    end
  end

  context 'with improper params' do
    context 'when name is blank' do
      let(:name) { nil }

      it 'does NOT create new course record' do
        expect { create_request.call }.not_to change { Course.count }
      end

      it 'returns proper http status' do
        create_request.call
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns proper http response body' do
        create_request.call
        expect(json_response).to eq ({ "name" => ["can't be blank"] })
      end
    end

    context 'when name already exists' do
      let!(:course) { create(:course, name: name, status: :active, driving_school: driving_school) }

      it 'does NOT create new course record' do
        expect { create_request.call }.not_to change { Course.count }
      end

      it 'returns proper http status' do
        create_request.call
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns proper http response body' do
        create_request.call
        expect(json_response).to eq ({"name"=>["There already exists such course with that status"]})
      end
    end

    context 'when course_participations_limit is not positive int' do
      let(:course_participations_limit) { -20.2 }

      it 'does NOT create new course record' do
        expect { create_request.call }.not_to change { Course.count }
      end

      it 'returns proper http status' do
        create_request.call
        expect(response).to have_http_status :unprocessable_entity
      end

      it 'returns proper http response body' do
        create_request.call
        expect(json_response).to eq ({"course_participations_limit"=>["must be an integer"]})
      end
    end
  end

  context 'Authorizations' do
    context 'when is an employee' do
      let(:current_user) { employee }

      it 'creates new course record' do
        expect { create_request.call }.to change { Course.count }.from(0).to(1)
      end
    end

    context 'when is a student' do
      let(:current_user) { student }

      it 'does NOT create new record' do
        expect { create_request.call }.not_to change { Course.count }
      end

      it 'returns unauthorized status' do
        create_request.call
        expect(response).to have_http_status :unauthorized
      end
    end

  end
end
