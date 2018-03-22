describe StudentDrivingSchool do
  context 'enumerators' do
    it { should define_enum_for(:status).with([:pending, :active, :archived, :rejected]) }
  end

  context 'relations' do
    it { should belong_to(:driving_school) }
    it { should belong_to(:student) }
    it { should have_one(:invitation) }
    it { should have_one(:driving_course) }
  end

  context 'validations' do
    it { should validate_presence_of(:status) }
  end
end
