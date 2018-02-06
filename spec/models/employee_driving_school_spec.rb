describe EmployeeDrivingSchool do
  context 'enumerators' do
    it { should define_enum_for(:status).with([:pending, :active, :archived, :rejected]) }
  end

  context 'relations' do
    it { should belong_to(:driving_school) }
    it { should belong_to(:employee) }
    it { should have_one(:employee_privilege_set) }
    it { should have_one(:employee_notifications_settings_set) }
    it { should have_one(:invitation) }
  end

  context 'validations' do
    it { should validate_presence_of(:status) }
  end
end
