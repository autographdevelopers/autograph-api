describe 'PUT /api/v1/driving_schools/:id' do
  let(:student) { create(:student) }
  let(:employee) { create(:employee) }

  let!(:student_driving_school) do
    create(:student_driving_school,
           student: student,
           driving_school: driving_school)
  end
  let!(:employee_driving_school) do
    create(:employee_driving_school,
           is_owner: is_owner,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:driving_school) { create(:driving_school) }

  let(:is_owner) { false }
  let(:response_keys) do
    %w[
      id name phone_numbers emails website_link additional_information city street
      country profile_picture zip_code status relation_status privileges
    ]
  end

  let(:params) do
    {
      driving_school: {
        name: 'Szkoła Łoś',
        phone_numbers: %w[345234532 234111444],
        emails: %w(szkolalos@gmail.com szkolaloskontakt@gmail.com),
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

  before do
    put "/api/v1/driving_schools/#{driving_school_id}", headers: current_user.create_new_auth_token, params: params
  end

  context 'when current_user is EMPLOYEE' do
    let(:current_user) { employee }

    context 'when accessing his driving school' do
      let(:driving_school_id) { driving_school.id }

      context 'when current_user is owner of driving_school' do
        let(:is_owner) { true }

        context 'when params are VALID' do
          it 'returns 200 http status code' do
            expect(response.status).to eq 200
          end

          it 'updated DrivingSchool record has proper attributes' do
            expect(driving_school.reload.attributes).to include(
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
              'longitude' => params[:driving_school][:longitude]
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
                'status' => driving_school.status
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
                  phone_numbers: [nil],
                  emails: [nil],
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
                'country' => ["can't be blank"],
                'street' => ["can't be blank"]
              )
            end
          end
        end
      end

      context 'when current_user is NOT owner of driving_school' do
        let(:is_owner) { false }

        it 'returns 401 http status code' do
          expect(response.status).to eq 401
        end
      end
    end

    context 'when is NOT accessing his driving school' do
      let(:driving_school_id) { create(:driving_school).id }
      let(:is_owner) { true }

      it 'returns 404 http status code' do
        expect(response.status).to eq 404
      end
    end
  end

  context 'when current_user is STUDENT' do
    let(:current_user) { student }
    let(:driving_school_id) { driving_school.id }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
