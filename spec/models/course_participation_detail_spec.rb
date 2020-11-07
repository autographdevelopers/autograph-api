describe CourseParticipationDetail do
  context 'relations' do
    it { should belong_to(:student_driving_school) }
  end

  context 'validations' do
    it { should validate_presence_of(:available_slot_credits) }
    it { should validate_numericality_of(:available_slot_credits).is_greater_than_or_equal_to(0) }
  end
end
