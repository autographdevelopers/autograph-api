# not_assigned_to_course_api_v1_driving_school_courses GET    /api/v1/driving_schools/:driving_school_id/courses/not_assigned_to_course(.:format)
#
describe 'GET /api/v1/driving_schools/:driving_school_id/courses/:course_id/not_assigned_to_course' do
  let(:employee) { create(:employee) }
  let(:student) { create(:student) }
  let(:student2) { create(:student) }
  let(:driving_school) { create(:driving_school, status: :active) }

  let(:is_owner) { true }
  let(:params) { {} }

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

  let!(:student_driving_school2) do
    create(:student_driving_school,
           student: student2,
           driving_school: driving_school,
           status: :active)
  end

  let(:current_user) { employee }

  let!(:active_course) { create(:course, driving_school: driving_school) }

  let!(:course_part_det_1) {
    create(:course_participation_detail,
      course: active_course,
      student_driving_school: student_driving_school,
      driving_school: driving_school
    )
  }

  let(:request) do
    -> { get not_assigned_to_course_api_v1_driving_school_course_students_path(driving_school, active_course), headers: current_user.create_new_auth_token, params: params }
  end

  it 'returns proper records' do
    request.call
    p json_response
  end
end