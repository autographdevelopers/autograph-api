context 'POST /api/v1/auth/confirmation' do
  let(:post_user_confirmation) { -> { post api_v1_user_confirmation_path, params: params } }
  let(:params) { { email: email } }

  context 'when user NOT confirmed' do
    let(:user) { create(:user, confirmed_at: nil) }

    context 'with VALID email' do
      let(:email) { user.email }

      it 'sends confirmation email' do
        expect { post_user_confirmation.call }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context 'with INVALID email' do
      let(:email) { 'wrong-email' }

      it 'does NOT send confirmation email' do
        expect { post_user_confirmation.call }.not_to change(ActionMailer::Base.deliveries, :count)
      end
    end
  end

  context 'when user confirmed and with VALID email' do
    let(:user) { create(:user) }
    let(:email) { user.email }

    it 'does NOT send confirmation email' do
      expect { post_user_confirmation.call }.not_to change(ActionMailer::Base.deliveries, :count)
    end
  end
end
