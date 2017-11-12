describe 'POST /api/v1/auth/password' do
  let(:params) { { email: email } }

  before do
    post '/api/v1/auth/password', params: params
  end

  context 'when given email exists' do
    let(:email) { create(:user).email }

    it 'sends reset password email' do
      expect(ActionMailer::Base.deliveries.count).to eq 1
    end

    it 'returns 200 http status code' do
      expect(response.status).to eq 200
    end
  end

  context 'when given email does NOT exist' do
    let(:email) { 'not-existing-email' }

    it 'does NOT send reset password email' do
      expect(ActionMailer::Base.deliveries.count).to eq 0
    end
  end

  context 'when given email is EMPTY' do
    let(:email) { '' }

    it 'does NOT send reset password email' do
      expect(ActionMailer::Base.deliveries.count).to eq 0
    end
  end
end
