describe 'GET /api/v1/driving_schools/:driving_school_id/courses' do
  let(:employee) { create(:employee) }
  let(:is_owner) { true }
  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let!(:courses) { create_list(:course, 5) }

  let(:index_request) { -> { get api_v1_driving_school_courses_path(driving_school), headers: employee.create_new_auth_token } }

  it 'does not crash' do
    index_request.call
    p json_response
  end
end