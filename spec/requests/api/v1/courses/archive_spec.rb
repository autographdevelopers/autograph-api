describe 'PUT /api/v1/driving_schools/:driving_school_id/courses/:id/archive' do
  let(:employee) { create(:employee) }
  let(:student) { create(:student) }
  let(:driving_school) { create(:driving_school, status: :active) }
  let(:is_owner) { true }
  let(:course_type) { create(:course_type, driving_school: driving_school) }
  let!(:course) { create(:course, status: :active, driving_school: driving_school, course_type: course_type) }

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

  let(:archive_request) do
    ->(course) {
      put archive_api_v1_driving_school_course_path(driving_school, course), headers: current_user.create_new_auth_token
    }
  end

  it 'changes status to archived' do
    expect { archive_request.call(course) }.to change { course.reload.status }.from('active').to('archived')
  end
end