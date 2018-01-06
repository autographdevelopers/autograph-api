describe StudentDrivingSchool do
  context 'enumerators' do
    it { should define_enum_for(:status).with([:pending, :active, :archived]) }
  end

  context 'relations' do
    it { should belong_to(:driving_school) }
    it { should belong_to(:student) }
    it { should have_one(:invitation) }
  end

  context 'validations' do
    it { should validate_presence_of(:status) }
  end
end
