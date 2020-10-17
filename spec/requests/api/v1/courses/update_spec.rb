describe 'PUT /api/v1/driving_schools/:driving_school_id/courses/:id' do
  let(:employee) { create(:employee) }
  let(:student) { create(:student) }
  let(:driving_school) { create(:driving_school, status: :active) }
  let(:is_owner) { true }
  let(:course_type) { create(:course_type, driving_school: driving_school) }

  let(:name) { 'test--updated' }
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

  let!(:course) { create(:course, name: 'test', status: :active, driving_school: driving_school) }

  let(:update_request) do
    -> (course) {
      put api_v1_driving_school_course_path(driving_school, course),
                      headers: current_user.create_new_auth_token,
                      params: params
    }
  end

  context 'when no assignments yet' do
    it 'updates name attr' do
      expect { update_request.call(course) }.to change { course.reload.name }.from('test').to('test--updated')
    end

    it 'returns proper http status' do
      update_request.call(course)
      expect(response).to have_http_status :ok
    end

    it 'returns proper http body' do
      update_request.call(course)
      course.reload
      expect(json_response).to eq({
        "id"=>course.id,
        "name"=>"test--updated",
        "description"=>"Test description",
        "status"=>"active",
        "start_time"=>nil,
        "end_time"=>nil,
        "driving_school_id"=>driving_school.id,
        "course_type"=>{"id"=>course.course_type.id, "name"=>"Test Course", "description"=>"Test Description", "status"=>"active"}
      })
    end
  end

  context 'when there are some students assigned to this course' do
    let!(:course_participation) { create(:course_participation, student_driving_school: student_driving_school, course: course) }

    it ' does NOT update' do
      expect { update_request.call(course) }.not_to change { course.reload.name }
    end

    it 'returns proper http status' do
      update_request.call(course)
      expect(response).to have_http_status :unprocessable_entity
    end

    it 'returns proper http response body' do
      update_request.call(course)
      expect(json_response).to eq ({"error"=>"Course is marked as readonly"})
    end
  end
end