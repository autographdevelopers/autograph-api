# api_v1_driving_school_course_participation_detail
#

describe 'PUT /api/v1/driving_schools/:driving_school_id/course_participation_details/:id' do
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

  let(:update_request) do
    ->(record) { put api_v1_driving_school_course_participation_detail_path(driving_school, record), headers: current_user.create_new_auth_token, params: params }
  end

  let!(:course_part_det_1) { create(:course_participation_detail, course: course_a, available_hours: 2, student_driving_school: student_driving_school, driving_school: driving_school)}

  context 'when params are valid' do
    it 'updates record' do
      expect { update_request.call(course_part_det_1) }.to change { course_part_det_1.reload.available_hours }.from(2).to(20)
    end

    it 'creates activity' do
      expect { update_request.call(course_part_det_1) }.to change { Activity.count }.from(0).to(1)
    end

    it 'returns 200 status code' do
      update_request.call(course_part_det_1)
      expect(response).to have_http_status :ok
    end
  end

  context 'Authorization' do
    context 'when current user is a student' do
      let(:current_user) { student }

      it 'does NOT create 1 new course_participation_details record' do
        expect { update_request.call(course_part_det_1) }.not_to change { course_part_det_1.reload.available_hours }
      end
    end
  end
end
