describe DrivingSchool do
  context 'enumerators' do
    it { should define_enum_for(:status).with([:pending, :active, :blocked, :removed]) }
  end

  context 'relations' do
    it { should have_many(:employee_driving_schools) }
    it { should have_many(:employees).through(:employee_driving_schools) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone_numbers) }
    it { should validate_presence_of(:emails) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:country) }
  end
end
