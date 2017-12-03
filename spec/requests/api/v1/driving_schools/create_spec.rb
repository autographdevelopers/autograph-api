describe 'POST /api/v1/driving_schools' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let(:response_keys) { %w(
    id name phone_numbers emails website_link additional_information city street country profile_picture zip_code status
  ) }

  before do
    post '/api/v1/driving_schools', headers: current_user.create_new_auth_token, params: params
  end

  let(:valid_params) do
    {
      driving_school: {
        name: 'Szkoła Łoś',
        phone_numbers: ['345234532', '234111444'],
        emails: ['szkolalos@gmail.com', 'szkolaloskontakt@gmail.com'],
        website_link: 'szkolalos.pl',
        additional_information: 'Lorem Ipsum',
        city: 'Lodz',
        zip_code: '91-345',
        street: 'Przybyszewskiego 108',
        country: 'Poland',
        profile_picture: 'image_base64',
        verification_code: SecureRandom.uuid,
        latitude: 33.413611,
        longitude: 44.412931
      }
    }
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when params are VALID' do
      let(:params) { valid_params }

      it 'returns 201 http status code' do
        expect(response.status).to eq 201
      end

      it 'creates DrivingSchool record' do
        expect(DrivingSchool.count).to eq 1
      end

      it 'creates EmployeeDrivingSchool record' do
        expect(EmployeeDrivingSchool.count).to eq 1
      end

      it 'creates EmployeePrivilegeSet record' do
        expect(EmployeePrivilegeSet.count).to eq 1
      end

      it 'created DrivingSchool record has proper attributes' do
        expect(DrivingSchool.last.attributes).to include(
                                                   'name' => params[:driving_school][:name],
                                                   'phone_numbers' => params[:driving_school][:phone_numbers],
                                                   'emails' => params[:driving_school][:emails],
                                                   'website_link' => params[:driving_school][:website_link],
                                                   'additional_information' => params[:driving_school][:additional_information],
                                                   'city' => params[:driving_school][:city],
                                                   'zip_code' => params[:driving_school][:zip_code],
                                                   'street' => params[:driving_school][:street],
                                                   'country' => params[:driving_school][:country],
                                                   'profile_picture' => params[:driving_school][:profile_picture],
                                                   'latitude' => params[:driving_school][:latitude],
                                                   'longitude' => params[:driving_school][:longitude],
                                                   'status' => 'built'
                                                 )
      end

      it 'created EmployeeDrivingSchool record has proper attributes' do
        expect(EmployeeDrivingSchool.last.attributes).to include(
                                                           'employee_id' => current_user.id,
                                                           'driving_school_id' => DrivingSchool.last.id
                                                         )
      end

      it 'created EmployeePrivilegeSet record has proper attributes' do
        expect(EmployeePrivilegeSet.last.attributes).to include(
                                                          'employee_driving_school_id' => EmployeeDrivingSchool.last.id,
                                                          'can_manage_employees' => true,
                                                          'can_manage_students' => true,
                                                          'can_modify_schedules' => true,
                                                          'is_driving' => false,
                                                          'is_owner' => true
                                                        )
      end

      context 'response body contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.keys).to match_array response_keys
        end

        it 'attributes' do
          expect(subject).to include(
                               'name' => params[:driving_school][:name],
                               'phone_numbers' => params[:driving_school][:phone_numbers],
                               'emails' => params[:driving_school][:emails],
                               'website_link' => params[:driving_school][:website_link],
                               'additional_information' => params[:driving_school][:additional_information],
                               'city' => params[:driving_school][:city],
                               'zip_code' => params[:driving_school][:zip_code],
                               'street' => params[:driving_school][:street],
                               'country' => params[:driving_school][:country],
                               'profile_picture' => params[:driving_school][:profile_picture],
                               'status' => 'built'
                             )
        end
      end
    end

    context 'when params are INVALID' do
      context 'all fields blank' do
        let(:params) do
          {
            driving_school: {
              name: '',
              phone_numbers: '',
              emails: '',
              website_link: '',
              additional_information: '',
              city: '',
              zip_code: '',
              street: '',
              country: '',
              profile_picture: '',
              verification_code: '',
              latitude: '',
              longitude: ''
            }
          }
        end

        it 'returns 422 http status code' do
          expect(response.status).to eq 422
        end

        it 'response contains proper error messages' do
          expect(json_response).to include(
                                     'name' => ["can't be blank"],
                                     'phone_numbers' => ["can't be blank"],
                                     'emails' => ["can't be blank"],
                                     'city' => ["can't be blank"],
                                     'zip_code' => ["can't be blank"],
                                     'country' => ["can't be blank"]
                                   )
        end
      end
    end
  end

  context 'when current_user is STUDENT and params are VALID' do
    let(:current_user) { student }
    let(:params) { valid_params }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
