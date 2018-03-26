describe 'GET /api/v1/driving_schools/:driving_school_id/driving_lessons' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           is_owner: is_owner,
           can_modify_schedules: can_modify_schedules,
           status: :active)
  end

  let(:is_owner) { false }
  let(:can_modify_schedules) { false }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end

  let!(:driving_lesson_1) do
    create(:driving_lesson,
           employee: employee,
           student: student,
           driving_school: driving_school,
           start_time: DateTime.new(2050, 2, 3, 12, 30, 0))
  end

  let!(:driving_lesson_2) do
    create(:driving_lesson,
           employee: employee,
           student: student,
           driving_school: driving_school,
           start_time: DateTime.new(2050, 2, 3, 12, 0, 0))
  end

  let!(:driving_lesson_3) do
    create(:driving_lesson,
           employee: employee,
           student: student,
           driving_school: driving_school,
           start_time: DateTime.new(2050, 2, 3, 13, 0, 0))
  end

  let(:params) do
    {
      employee_id: employee.id,
      driving_lessons_ids: [driving_lesson_2.id, driving_lesson_3.id]
    }
  end

  before do
    get "/api/v1/driving_schools/#{driving_school.id}/driving_lessons",
        headers: current_user.create_new_auth_token,
        params: params
  end

  let(:current_user) { employee }

  it 'test' do
    p json_response
  end
end
