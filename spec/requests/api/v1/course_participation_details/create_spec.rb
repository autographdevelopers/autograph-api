describe 'POST api/v1/driving_schools/:driving_school_id/courses/:course_id/students/:student_id/course_participation_details' do
  let(:employee) { create(:employee) }
  let(:student) { create(:student) }
  let(:student_2) { create(:student) }
  let(:is_owner) { true }
  let(:available_hours) { 20 }
  let(:params) { { course_participation_detail: { available_hours: available_hours } } }
  let(:driving_school) { create(:driving_school, status: :active) }
  let(:current_user) { employee }

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

  let!(:student_driving_school_2) do
    create(:student_driving_school,
           student: student_2,
           driving_school: driving_school,
           status: :active)
  end

  let(:course_type) { create(:course_type, driving_school: driving_school) }
  let!(:course_a) { create(:course, course_type: course_type, status: :active, driving_school: driving_school) }

  let(:course_type) { create(:course_type, driving_school: driving_school) }
  let!(:course_b) { create(:course, course_type: course_type, status: :active, driving_school: driving_school) }

  let(:create_request) do
    ->(student) {
      post api_v1_driving_school_course_student_course_participation_details_path(driving_school, course_a, student),
                      headers: current_user.create_new_auth_token,
                      params: params
    }
  end

  context 'when params are valid' do
    it 'creates 1 new course_participation_details record' do
      expect { create_request.call(student) }.to change { CourseParticipationDetail.count }.from(0).to(1)
    end

    it 'returns 200 status code' do
      create_request.call(student)
      expect(response).to have_http_status :ok
    end
  end

  context 'when trying to assign students to the same course more than once' do
    before { create_request.call(student) }

    it 'does NOT create 1 new course_participation_details record' do
      expect { create_request.call(student) }.not_to change { CourseParticipationDetail.count }
    end

    it 'returns 422 status code' do
      create_request.call(student)
      expect(response).to have_http_status 422
    end

    it 'contains proper error msg in response body' do
      create_request.call(student)
      expect(json_response).to eq ({"student_driving_school_id"=>["has already been taken"]})
    end
  end

  context 'when improper params' do
    context 'improper available hours attr' do
      let(:available_hours) { -20 }

      it 'does NOT create 1 new course_participation_details record' do
        expect { create_request.call(student) }.not_to change { CourseParticipationDetail.count }
      end

      it 'returns 422 status code' do
        create_request.call(student)
        expect(response).to have_http_status 422
      end

      it 'contains proper error msg in response body' do
        create_request.call(student)
        expect(json_response).to eq ({"available_hours"=>["must be greater than or equal to 0"]})
      end
    end
  end

  context 'Authorization' do
    context 'when current user is a student' do
      let(:current_user) { student }

      it 'does NOT create 1 new course_participation_details record' do
        expect { create_request.call(student) }.not_to change { CourseParticipationDetail.count }
      end
    end
  end
end
