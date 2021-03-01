describe User do
  context 'enumerators' do
    it {should define_enum_for(:status).with([:active, :blocked, :removed]) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:surname) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:birth_date) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:time_zone) }

    it { should allow_values(1.year.ago, 2.years.ago).for(:birth_date) }
    it { should_not allow_values(1.year.from_now, 3.years.from_now).for(:birth_date) }
  end
end
