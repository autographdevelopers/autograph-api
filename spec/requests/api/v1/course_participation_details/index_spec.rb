describe 'course participation details [INDEX]' do
  let(:employee) { create(:employee) }
  let(:student) { create(:student) }
  let(:student_2) { create(:student) }
  let(:is_owner) { true }
  let(:params) { {} }
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

  let(:index_request) do
    ->(record) { get "/api/v1/driving_schools/#{driving_school.id}/#{record.model_name.plural}/#{record.id}/course_participation_details", headers: current_user.create_new_auth_token, params: params }
  end

  let!(:course_part_det_1) { create(:course_participation_detail, course: course_a, student_driving_school: student_driving_school)}
  let!(:course_part_det_2) { create(:course_participation_detail, course: course_a, student_driving_school: student_driving_school_2)}

  context 'GET /api/v1/driving_schools/:driving_school_id/students/:student_id/course_participation_details' do
    let(:current_user) { student }

    let!(:other_student) { create(:student) }
    let!(:other_student_driving_school) do
      create(:student_driving_school,
             student: other_student,
             driving_school: driving_school,
             status: :active)
    end

    before { index_request.call(student) }

    it 'returns 200 http status' do
      expect(response).to have_http_status :ok
    end

    it 'returns proper record in http response body' do
      expect(json_response['results'].pluck('id')).to contain_exactly course_part_det_1.id
    end

    context 'Authorization' do
      context 'when student tries to access data about course participation details not belonging to her' do

        let(:current_user) { other_student }

        it 'returns 401 http status' do
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end

  context 'GET /api/v1/driving_schools/:driving_school_id/courses/:course_id/course_participation_details' do
    let(:current_user) { employee }

    before { index_request.call(course_a) }

    it 'returns 200 http status' do
      expect(response).to have_http_status :ok
    end

    it 'returns proper record in http response body' do
      expect(json_response['results'].pluck('id')).to contain_exactly course_part_det_1.id, course_part_det_2.id
    end

    context 'Authorization' do
      context 'when student tries to access all participation data for all particular course' do

        let(:current_user) { student }

        it 'returns 401 http status' do
          expect(response).to have_http_status :unauthorized
        end
      end
    end
  end
end
