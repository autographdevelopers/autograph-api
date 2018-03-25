describe DrivingLesson do
  context 'relations' do
    it { should belong_to(:driving_school) }
    it { should belong_to(:employee) }
    it { should belong_to(:student) }
    it { should have_many(:slots) }
  end

  context 'validations' do
    it { should validate_presence_of(:start_time) }
  end
end
