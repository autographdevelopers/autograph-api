describe Slot do
  context 'relations' do
    it { should belong_to(:employee_driving_school) }
    it { should belong_to(:driving_lesson) }
  end

  context 'validations' do
    it { should validate_presence_of(:start_time) }
  end
end
