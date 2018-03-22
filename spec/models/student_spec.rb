describe Student do
  context 'relations' do
    it { should have_many(:student_driving_schools) }
    it { should have_many(:driving_schools).through(:student_driving_schools) }
    it { should have_many(:driving_lessons) }
  end

  context 'callbacks' do
    context '#find_pending_invitation' do
      let(:student_driving_school_1) { create(:student_driving_school, status: :pending, student: nil) }
      let(:student_driving_school_2) { create(:student_driving_school, status: :pending, student: nil) }

      let!(:invitation_1) { create(:invitation, email: 'test@gmail.com', invitable: student_driving_school_1) }
      let!(:invitation_2) { create(:invitation, email: 'test@gmail.com', invitable: student_driving_school_2) }

      it 'is invoked after create' do
        student = build(:student)
        expect(student).to receive(:find_pending_invitation_and_relate_user_to_driving_school)
        student.save
      end

      it 'finds pending invitations and assigns student to driving_school' do
        student = create(:student, email: 'test@gmail.com')
        expect(student.student_driving_schools.pluck(:id)).to match_array [student_driving_school_1.id, student_driving_school_2.id]
      end
    end
  end
end
