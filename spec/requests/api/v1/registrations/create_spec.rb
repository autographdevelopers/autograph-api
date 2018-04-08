describe 'POST /api/v1/auth' do
  let(:response_keys) do
    %w[
      id email name surname gender birth_date type time_zone
    ]
  end

  let(:valid_params) do
    {
      email: 'test@gmail.com',
      password: 'Password1!',
      confirm_password: 'Password1!',
      name: 'TestName',
      surname: 'TestSurname',
      gender: 'male',
      type: type,
      birth_date: 18.years.ago,
      time_zone: '+00:00'
    }
  end

  before do
    post '/api/v1/auth', params: params
  end

  context 'when type is Student' do
    let(:type) { User::STUDENT }

    context 'when params VALID' do
      let(:params) { valid_params }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      subject { User.last }

      it 'created user is active' do
        expect(subject.status).to eq 'active'
      end

      it 'created user is NOT confirmed' do
        expect(subject.confirmed_at).to be nil
      end

      it 'sends confirmation email' do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end

      it 'created record has proper password' do
        expect(subject.valid_password?(params[:password])).to eq true
      end

      context 'response contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.keys).to match_array response_keys
        end

        it 'email' do
          expect(subject['email']).to eq params[:email]
        end

        it 'name' do
          expect(subject['name']).to eq params[:name]
        end

        it 'surname' do
          expect(subject['surname']).to eq params[:surname]
        end

        it 'gender' do
          expect(subject['gender']).to eq params[:gender]
        end

        it 'type' do
          expect(subject['type']).to eq params[:type]
        end

        it 'birth_date' do
          expect(subject['birth_date']).to eq params[:birth_date].strftime('%F')
        end

        it 'time_zone' do
          expect(subject['time_zone']).to eq params[:time_zone]
        end
      end
    end

    context 'when params INVALID' do
      context 'all fields blank' do
        let(:params) do
          {
            email: '',
            password: '',
            confirm_password: '',
            name: '',
            surname: '',
            gender: '',
            type: '',
            birth_date: '',
            time_zone: ''
          }
        end

        it 'returns 422 http status code' do
          expect(response.status).to eq 422
        end

        it 'response contains email error messages' do
          expect(json_response['email']).to eq ["can't be blank"]
        end

        it 'response contains name error message' do
          expect(json_response['name']).to eq ["can't be blank"]
        end

        it 'response contains surname error message' do
          expect(json_response['surname']).to eq ["can't be blank"]
        end

        it 'response contains gender error message' do
          expect(json_response['gender']).to eq ["can't be blank"]
        end

        it 'response contains type error message' do
          expect(json_response['type']).to eq ["can't be blank"]
        end

        it 'response contains birth_date error message' do
          expect(json_response['birth_date']).to eq ["can't be blank"]
        end

        it 'response contains time_zone error message' do
          expect(json_response['time_zone']).to eq ["can't be blank"]
        end
      end

      context 'email already taken' do
        let!(:user) { create(:user, email: 'test@gmail.com') }
        let(:params) { { email: user.email } }

        it 'returns 422 http status code' do
          expect(response.status).to eq 422
        end

        xit 'response contains email error message' do
          expect(json_response['email']).to eq ['has already been taken']
        end
      end

      context 'password is to short' do
        let(:params) { { password: 'passwrd' } }

        it 'returns 422 http status code' do
          expect(response.status).to eq 422
        end

        it 'response contains password error message' do
          expect(json_response['password']).to eq ['is too short (minimum is 8 characters)']
        end
      end
    end
  end

  context 'when type is Employee' do
    let(:type) { User::EMPLOYEE }

    context 'when params VALID' do
      let(:params) { valid_params }

      it 'returns 200 http status code' do
        expect(response.status).to eq 200
      end

      subject { User.last }

      it 'created user is active' do
        expect(subject.status).to eq 'active'
      end

      it 'created user is NOT confirmed' do
        expect(subject.confirmed_at).to be nil
      end

      it 'sends confirmation email' do
        expect(ActionMailer::Base.deliveries.count).to eq 1
      end

      it 'created record has proper password' do
        expect(subject.valid_password?(params[:password])).to eq true
      end

      context 'response contains proper' do
        subject { json_response }

        it 'keys' do
          expect(subject.keys).to match_array response_keys
        end

        it 'email' do
          expect(subject['email']).to eq params[:email]
        end

        it 'name' do
          expect(subject['name']).to eq params[:name]
        end

        it 'surname' do
          expect(subject['surname']).to eq params[:surname]
        end

        it 'gender' do
          expect(subject['gender']).to eq params[:gender]
        end

        it 'type' do
          expect(subject['type']).to eq params[:type]
        end

        it 'birth_date' do
          expect(subject['birth_date']).to eq params[:birth_date].strftime('%F')
        end

        it 'time_zone' do
          expect(subject['time_zone']).to eq params[:time_zone]
        end
      end
    end

    context 'when params INVALID' do
      context 'all fields blank' do
        let(:params) do
          {
            email: '',
            password: '',
            confirm_password: '',
            name: '',
            surname: '',
            gender: '',
            type: '',
            birth_date: '',
            time_zone: ''
          }
        end

        it 'returns 422 http status code' do
          expect(response.status).to eq 422
        end

        it 'response contains email error messages' do
          expect(json_response['email']).to eq ["can't be blank"]
        end

        it 'response contains name error message' do
          expect(json_response['name']).to eq ["can't be blank"]
        end

        it 'response contains surname error message' do
          expect(json_response['surname']).to eq ["can't be blank"]
        end

        it 'response contains gender error message' do
          expect(json_response['gender']).to eq ["can't be blank"]
        end

        it 'response contains type error message' do
          expect(json_response['type']).to eq ["can't be blank"]
        end

        it 'response contains birth_date error message' do
          expect(json_response['birth_date']).to eq ["can't be blank"]
        end

        it 'response contains time_zone error message' do
          expect(json_response['time_zone']).to eq ["can't be blank"]
        end
      end

      context 'email already taken' do
        let!(:user) { create(:user, email: 'test@gmail.com') }
        let(:params) { { email: user.email } }

        it 'returns 422 http status code' do
          expect(response.status).to eq 422
        end

        xit 'response contains email error message' do
          expect(json_response['email']).to eq ['has already been taken']
        end
      end

      context 'password is to short' do
        let(:params) { { password: 'passwrd' } }

        it 'returns 422 http status code' do
          expect(response.status).to eq 422
        end

        it 'response contains password error message' do
          expect(json_response['password']).to eq ['is too short (minimum is 8 characters)']
        end
      end
    end
  end

  context 'when type is UNKNOWN and params are VALID' do
    let(:type) { 'UnknownRole' }
    let(:params) { valid_params }

    it 'returns 422 http status code' do
      expect(response.status).to eq 422
    end

    it 'response contains type error message' do
      expect(json_response['type']).to eq ['must by either Student or Employee']
    end
  end
end
