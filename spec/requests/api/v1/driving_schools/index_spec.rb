describe 'GET /api/v1/driving_schools' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:driving_school_1) { create(:driving_school, status: :pending) }
  let!(:driving_school_2) { create(:driving_school, status: :active) }
  let!(:driving_school_3) { create(:driving_school, status: :blocked) }
  let!(:driving_school_4) { create(:driving_school, status: :removed) }
  let!(:driving_school_5) { create(:driving_school, status: :pending) }
  let!(:driving_school_6) { create(:driving_school, status: :active) }
  let!(:driving_school_7) { create(:driving_school, status: :blocked) }
  let!(:driving_school_8) { create(:driving_school, status: :removed) }
  let!(:driving_school_9) { create(:driving_school, status: :pending) }
  let!(:driving_school_10) { create(:driving_school, status: :active) }
  let!(:driving_school_11) { create(:driving_school, status: :blocked) }
  let!(:driving_school_12) { create(:driving_school, status: :removed) }

  let!(:employee_driving_school_1) { create(:employee_driving_school, employee: employee, driving_school: driving_school_1, status: :pending) }
  let!(:employee_driving_school_2) { create(:employee_driving_school, employee: employee, driving_school: driving_school_2, status: :pending) }
  let!(:employee_driving_school_3) { create(:employee_driving_school, employee: employee, driving_school: driving_school_3, status: :pending) }
  let!(:employee_driving_school_4) { create(:employee_driving_school, employee: employee, driving_school: driving_school_4, status: :pending) }
  let!(:employee_driving_school_5) { create(:employee_driving_school, employee: employee, driving_school: driving_school_5, status: :active) }
  let!(:employee_driving_school_6) { create(:employee_driving_school, employee: employee, driving_school: driving_school_6, status: :active) }
  let!(:employee_driving_school_7) { create(:employee_driving_school, employee: employee, driving_school: driving_school_7, status: :active) }
  let!(:employee_driving_school_8) { create(:employee_driving_school, employee: employee, driving_school: driving_school_8, status: :active) }
  let!(:employee_driving_school_9) { create(:employee_driving_school, employee: employee, driving_school: driving_school_9, status: :archived) }
  let!(:employee_driving_school_10) { create(:employee_driving_school, employee: employee, driving_school: driving_school_10, status: :archived) }
  let!(:employee_driving_school_11) { create(:employee_driving_school, employee: employee, driving_school: driving_school_11, status: :archived) }
  let!(:employee_driving_school_12) { create(:employee_driving_school, employee: employee, driving_school: driving_school_12, status: :archived) }

  let!(:student_driving_school_1) { create(:student_driving_school, student: student, driving_school: driving_school_1, status: :pending) }
  let!(:student_driving_school_2) { create(:student_driving_school, student: student, driving_school: driving_school_2, status: :pending) }
  let!(:student_driving_school_3) { create(:student_driving_school, student: student, driving_school: driving_school_3, status: :pending) }
  let!(:student_driving_school_4) { create(:student_driving_school, student: student, driving_school: driving_school_4, status: :pending) }
  let!(:student_driving_school_5) { create(:student_driving_school, student: student, driving_school: driving_school_5, status: :active) }
  let!(:student_driving_school_6) { create(:student_driving_school, student: student, driving_school: driving_school_6, status: :active) }
  let!(:student_driving_school_7) { create(:student_driving_school, student: student, driving_school: driving_school_7, status: :active) }
  let!(:student_driving_school_8) { create(:student_driving_school, student: student, driving_school: driving_school_8, status: :active) }
  let!(:student_driving_school_9) { create(:student_driving_school, student: student, driving_school: driving_school_9, status: :archived) }
  let!(:student_driving_school_10) { create(:student_driving_school, student: student, driving_school: driving_school_10, status: :archived) }
  let!(:student_driving_school_11) { create(:student_driving_school, student: student, driving_school: driving_school_11, status: :archived) }
  let!(:student_driving_school_12) { create(:student_driving_school, student: student, driving_school: driving_school_12, status: :archived) }

  before do
    get api_v1_driving_schools_path, headers: current_user.create_new_auth_token
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    it 'returns 200 http status code' do
      expect(response.status).to eq 200
    end

    it 'returned records contain proper keys' do
      expect(json_response.first.keys).to match_array %w(id name phone_numbers emails website_link additional_information
                                                         city street country profile_picture status student_driving_school_status
                                                         zip_code)
    end

    it 'returns proper records' do
      expect(json_response.pluck('id')).to match_array [
                                                         driving_school_1.id, driving_school_2.id, driving_school_3.id,
                                                         driving_school_5.id, driving_school_6.id, driving_school_7.id
                                                       ]
    end

    it 'response contains driving school attributes' do
      expect(json_response.first).to eq({
                                          'id' => driving_school_1.id,
                                          'name' => driving_school_1.name,
                                          'phone_numbers' => driving_school_1.phone_numbers,
                                          'emails' => driving_school_1.emails,
                                          'website_link' => driving_school_1.website_link,
                                          'additional_information' => driving_school_1.additional_information,
                                          'city' => driving_school_1.city,
                                          'street' => driving_school_1.street,
                                          'country' => driving_school_1.country,
                                          'profile_picture' => driving_school_1.profile_picture,
                                          'status' => driving_school_1.status,
                                          'zip_code' => driving_school_1.zip_code,
                                          'student_driving_school_status' => employee_driving_school_1.status
                                        })
    end
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    it 'returns 200 http status code' do
      expect(response.status).to eq 200
    end

    it 'returned records contain proper keys' do
      expect(json_response.first.keys).to match_array %w(id name phone_numbers emails website_link additional_information
                                                         city street country profile_picture zip_code status
                                                         employee_driving_school_status privilege_set)
    end

    it 'returned records contain proper keys for privilege_set' do
      expect(json_response.first['privilege_set'].keys).to match_array %w(id can_manage_employees can_manage_students
                                                                          can_modify_schedules is_driving is_owner)
    end

    it 'returns proper records' do
      expect(json_response.pluck('id')).to match_array [
                                                         driving_school_1.id, driving_school_2.id, driving_school_3.id,
                                                         driving_school_5.id, driving_school_6.id, driving_school_7.id
                                                       ]
    end

    it 'response contains driving school attributes' do
      expect(json_response.first).to eq({
                                          'id' => driving_school_1.id,
                                          'name' => driving_school_1.name,
                                          'phone_numbers' => driving_school_1.phone_numbers,
                                          'emails' => driving_school_1.emails,
                                          'website_link' => driving_school_1.website_link,
                                          'additional_information' => driving_school_1.additional_information,
                                          'city' => driving_school_1.city,
                                          'street' => driving_school_1.street,
                                          'country' => driving_school_1.country,
                                          'profile_picture' => driving_school_1.profile_picture,
                                          'status' => driving_school_1.status,
                                          'zip_code' => driving_school_1.zip_code,
                                          'employee_driving_school_status' => employee_driving_school_1.status,
                                          'privilege_set' => {
                                            'id' => employee_driving_school_1.id,
                                            'can_manage_employees' => employee_driving_school_1.employee_privilege_set.can_manage_employees,
                                            'can_manage_students' => employee_driving_school_1.employee_privilege_set.can_manage_students,
                                            'can_modify_schedules' => employee_driving_school_1.employee_privilege_set.can_modify_schedules,
                                            'is_driving' => employee_driving_school_1.employee_privilege_set.is_driving,
                                            'is_owner' => employee_driving_school_1.employee_privilege_set.is_owner,
                                          }
                                        })
    end
  end
end
