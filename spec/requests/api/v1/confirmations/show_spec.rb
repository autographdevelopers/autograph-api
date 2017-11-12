describe 'GET /api/v1/auth/confirmation' do
  let(:user) { create(:user, confirmed_at: nil) }
  let(:params) { { confirmation_token: confirmation_token, redirect_url: '/' } }

  before do
    get api_v1_user_confirmation_path, params: params
  end

  context 'when confirmation token VALID' do
    let(:confirmation_token) { user.confirmation_token }

    it 'redirects' do
      expect(response).to be_redirect
    end

    it 'confirms user ' do
      expect(user.reload.confirmed_at).not_to be_nil
    end
  end

  context 'when confirmation token INVALID' do
    let(:confirmation_token) { 'invalid-token' }

    it 'returns 404 http status code' do
      expect(response.status).to eq 404
    end
  end

  context 'when LACKS confirmation token' do
    let(:confirmation_token) { nil }

    it 'returns 404 http status code' do
      expect(response.status).to eq 404
    end
  end
end
