describe Employee do
  context 'relations' do
    it { should have_many(:employee_driving_schools) }
    it { should have_many(:driving_schools).through(:employee_driving_schools) }
    it { should have_many(:driving_lessons) }
  end

  context 'callbacks' do
    context '#find_pending_invitation' do
      let(:employee_driving_school_1) { create(:employee_driving_school, status: :pending, employee: nil) }
      let(:employee_driving_school_2) { create(:employee_driving_school, status: :pending, employee: nil) }

      let!(:invitation_1) { create(:invitation, email: 'test@gmail.com', invitable: employee_driving_school_1) }
      let!(:invitation_2) { create(:invitation, email: 'test@gmail.com', invitable: employee_driving_school_2) }

      it 'is invoked after create' do
        employee = build(:employee)
        expect(employee).to receive(:find_pending_invitation_and_relate_user_to_driving_school)
        employee.save
      end

      it 'finds pending invitations and assigns employee to driving_school' do
        employee = create(:employee, email: 'test@gmail.com')
        expect(employee.employee_driving_schools.pluck(:id)).to match_array [employee_driving_school_1.id, employee_driving_school_2.id]
      end
    end
  end
end
