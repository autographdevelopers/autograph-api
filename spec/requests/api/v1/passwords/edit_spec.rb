describe 'GET /api/v1/auth/password/edit' do
  let(:params) { { reset_password_token: reset_password_token, redirect_url: '/' } }

  before do
    get edit_api_v1_user_password_path, params: params
  end

  context 'with VALID reset password token' do
    let(:reset_password_token) { create(:user).send_reset_password_instructions }

    it 'redirects' do
      expect(response).to be_redirect
    end
  end

  context 'when reset password token INVALID' do
    let(:reset_password_token) { 'invalid-token' }

    it 'returns 404 http status code' do
      expect(response.status).to eq 404
    end
  end

  context 'when LACKS reset password token' do
    let(:reset_password_token) { nil }

    it 'returns 404 http status code' do
      expect(response.status).to eq 404
    end
  end
end
