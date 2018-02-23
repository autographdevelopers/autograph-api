describe DrivingLesson do
  context 'relations' do
    it { should belong_to(:employee_driving_school) }
    it { should belong_to(:student_driving_school) }
  end

  context 'validations' do
    it { should validate_presence_of(:start_time) }
  end
end
