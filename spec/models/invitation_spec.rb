describe Invitation do
  context 'relations' do
    it { should belong_to(:invitable) }
  end

  context 'validations' do
    it { should validate_presence_of(:email) }
  end
end
