describe EmployeePrivileges do
  context 'relations' do
    it { should belong_to(:employee_driving_school) }
  end

  context 'validations' do
    it { should validate_inclusion_of(:can_manage_employees).in_array([true, false]) }
    it { should validate_inclusion_of(:can_manage_students).in_array([true, false]) }
    it { should validate_inclusion_of(:can_modify_schedules).in_array([true, false]) }
    it { should validate_inclusion_of(:is_driving).in_array([true, false]) }
    it { should validate_inclusion_of(:is_owner).in_array([true, false]) }
  end
end
