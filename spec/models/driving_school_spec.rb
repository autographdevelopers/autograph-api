describe DrivingSchool do
  context 'enumerators' do
    it { should define_enum_for(:status).with([:built, :pending, :active, :blocked, :removed]) }
  end

  context 'relations' do
    it { should have_many(:employee_driving_schools) }
    it { should have_many(:employees).through(:employee_driving_schools) }
    it { should have_many(:student_driving_schools) }
    it { should have_many(:students).through(:student_driving_schools) }
    it { should have_many(:schedule_boundaries) }
    it { should have_one(:schedule_settings_set) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:phone_numbers) }
    it { should validate_presence_of(:emails) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:country) }
  end

  context 'state machines' do
    let!(:employee) { create(:employee) }
    let!(:driving_school) { create(:driving_school, status: :built) }

    it 'can transit from built to pending when requirements fulfilled' do
      create(:employee_driving_school, is_owner: true, employee: employee, driving_school: driving_school)
      create(:schedule_settings_set, driving_school: driving_school)
      expect(driving_school).to transition_from(:built).to(:pending).on_event(:confirm_registration)
    end

    it 'can NOT transit from built to pending when requirements are NOT fulfilled' do
      expect(driving_school).to_not allow_event(:confirm_registration)
    end
  end
end
