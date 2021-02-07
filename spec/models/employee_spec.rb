describe Employee do
  context 'relations' do
    it { should have_many(:employee_driving_schools) }
    it { should have_many(:driving_schools).through(:employee_driving_schools) }
    it { should have_many(:driving_lessons) }
  end
end
