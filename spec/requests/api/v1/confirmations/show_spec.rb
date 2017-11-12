describe 'GET /api/v1/auth/confirmation' do
  let(:user) { create(:user, confirmed_at: nil) }
  let(:params) { { confirmation_token: confirmation_token } }

  before do
    get api_v1_user_confirmation_path, params: params
  end

  context 'when confirmation token VALID' do
    let(:confirmation_token) { user.confirmation_token }

    it 'returns 202 http status code' do
      expect(response.status).to eq 202
    end
  end

  context 'when confirmation token INVALID' do
    let(:confirmation_token) { 'invalid-token' }

    it 'returns 422 http status code' do
      expect(response.status).to eq 422
    end
  end

  context 'when LACKS confirmation token' do
    let(:confirmation_token) { nil }

    it 'returns 422 http status code' do
      expect(response.status).to eq 422
    end
  end
end
