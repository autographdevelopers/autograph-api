describe 'POST /api/v1/auth/sign_in' do
  let(:response_keys) { %w(
    id email name surname birth_date type time_zone
  ) }

  let(:params) { { email: email, password: password } }

  before do
    post api_v1_user_session_path, params: params
  end

  context 'when email and password are VALID' do
    let(:user) { create(:user, password: 'password') }
    let(:email) { user.email }
    let(:password) { 'password' }

    it 'returns 200 http status code' do
      expect(response.status).to eq 200
    end

    it 'response header contains authentication information' do
      expect(response.header).to include("access-token", "token-type", "client", "expiry")
    end

    context 'response body contains proper' do
      subject { json_response }

      it 'keys' do
        expect(subject.keys).to match_array response_keys
      end

      it 'email' do
        expect(subject['email']).to eq user.email
      end

      it 'name' do
        expect(subject['name']).to eq user.name
      end

      it 'surname' do
        expect(subject['surname']).to eq user.surname
      end

      it 'type' do
        expect(subject['type']).to eq user.type
      end

      it 'birth_date' do
        expect(subject['birth_date']).to eq user.birth_date.strftime('%F')
      end

      it 'time_zone' do
        expect(subject['time_zone']).to eq user.time_zone
      end
    end
  end

  context 'when email and password are VALID BUT user is not confirmed' do
    let(:user) { create(:user, password: 'password', confirmed_at: nil) }
    let(:email) { user.email }
    let(:password) { 'password' }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end

  context 'when email or password are INVALID' do
    let(:email) { 'invalid-email' }
    let(:password) { 'invalid_password' }

    it 'returns 401 http status code' do
      expect(response.status).to eq 401
    end
  end
end
