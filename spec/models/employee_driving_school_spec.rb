describe EmployeeDrivingSchool do
  context 'enumerators' do
    it { should define_enum_for(:status).with([:pending, :active, :archived, :rejected]) }
  end

  context 'relations' do
    it { should belong_to(:driving_school) }
    it { should belong_to(:employee) }
    it { should have_one(:employee_privileges) }
    it { should have_one(:employee_notifications_settings) }
    it { should have_one(:invitation) }
    it { should have_one(:schedule) }
    it { should have_many(:slots) }
  end

  context 'validations' do
    it { should validate_presence_of(:status) }
  end
end
