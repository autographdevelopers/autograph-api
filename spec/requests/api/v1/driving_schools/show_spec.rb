describe 'GET /api/v1/driving_schools/:id' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school,
           status: :active)
  end
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:driving_school) { create(:driving_school, status: :active) }

  let(:response_keys) do
    %w[
      id name phone_numbers emails website_link additional_information city
      street country profile_picture zip_code status
    ]
  end

  before do
    get "/api/v1/driving_schools/#{driving_school_id}", headers: current_user.create_new_auth_token
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }

    context 'when accessing driving school that he belongs to' do
      let(:driving_school_id) { driving_school.id }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      it 'returned records contain proper keys' do
        expect(json_response.keys).to match_array %w[id name phone_numbers emails website_link additional_information
                                                     city street country profile_picture status relation_status
                                                     zip_code]
      end

      it 'response contains driving school attributes' do
        expect(json_response).to eq(
          'id' => driving_school.id,
          'name' => driving_school.name,
          'phone_numbers' => driving_school.phone_numbers,
          'emails' => driving_school.emails,
          'website_link' => driving_school.website_link,
          'additional_information' => driving_school.additional_information,
          'city' => driving_school.city,
          'street' => driving_school.street,
          'country' => driving_school.country,
          'profile_picture' => driving_school.profile_picture,
          'status' => driving_school.status,
          'zip_code' => driving_school.zip_code,
          'relation_status' => student_driving_school.status
        )
      end
    end

    context 'when accessing driving school that he does NOT belong to' do
      let(:driving_school_id) { create(:driving_school).id }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing driving school that he belongs to' do
      let(:driving_school_id) { driving_school.id }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      it 'returned records contain proper keys' do
        expect(json_response.keys).to match_array %w[id name phone_numbers emails website_link additional_information
                                                     city street country profile_picture zip_code status
                                                     relation_status privilege_set]
      end

      it 'returned records contain proper keys for privilege_set' do
        expect(json_response['privilege_set'].keys).to match_array %w[id can_manage_employees can_manage_students
                                                                      can_modify_schedules is_driving is_owner]
      end

      it 'response contains driving school attributes' do
        expect(json_response).to eq(
          'id' => driving_school.id,
          'name' => driving_school.name,
          'phone_numbers' => driving_school.phone_numbers,
          'emails' => driving_school.emails,
          'website_link' => driving_school.website_link,
          'additional_information' => driving_school.additional_information,
          'city' => driving_school.city,
          'street' => driving_school.street,
          'country' => driving_school.country,
          'profile_picture' => driving_school.profile_picture,
          'status' => driving_school.status,
          'zip_code' => driving_school.zip_code,
          'relation_status' => employee_driving_school.status,
          'privilege_set' => {
            'id' => employee_driving_school.id,
            'can_manage_employees' => employee_driving_school.employee_privileges.can_manage_employees,
            'can_manage_students' => employee_driving_school.employee_privileges.can_manage_students,
            'can_modify_schedules' => employee_driving_school.employee_privileges.can_modify_schedules,
            'is_driving' => employee_driving_school.employee_privileges.is_driving,
            'is_owner' => employee_driving_school.employee_privileges.is_owner
          }
        )
      end
    end

    context 'when accessing driving school that he does NOT belong to' do
      let(:driving_school_id) { create(:driving_school).id }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end
end
