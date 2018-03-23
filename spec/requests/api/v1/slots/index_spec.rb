describe 'GET /api/v1/driving_schools/:driving_school_id/employees/:employee_id/slots' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
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

  let!(:slot_1) do
    create(:slot,
           employee_driving_school: employee_driving_school,
           start_time: 1.day.from_now)
  end

  let!(:slot_2) do
    create(:slot,
           employee_driving_school: employee_driving_school,
           start_time: 2.day.from_now)
  end

  let!(:slot_3) do
    create(:slot,
           employee_driving_school: employee_driving_school,
           start_time: 3.day.from_now)
  end

  let(:params) do
    {
      by_start_time: {
        from: 2.day.from_now,
        to: 3.day.from_now
      }
    }
  end

  before do
    get api_v1_driving_school_employee_slots_path(driving_school.id, employee.id),
        headers: current_user.create_new_auth_token,
        params: params
  end

  let(:current_user) { student }

  it 'sdfsda' do
    p json_response
  end
end
