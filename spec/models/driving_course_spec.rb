describe DrivingCourse do
  context 'enumerators' do
    it { should define_enum_for(:category_type).with([:b]) }
  end

  context 'relations' do
    it { should belong_to(:student_driving_school) }
  end

  context 'validations' do
    it { should validate_presence_of(:available_hours) }
    it { should validate_presence_of(:category_type) }
    it { should validate_numericality_of(:available_hours).is_greater_than_or_equal_to(0) }
  end
end
