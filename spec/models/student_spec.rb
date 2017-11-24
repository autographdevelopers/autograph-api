describe Student do
  context 'relations' do
    it { should have_many(:student_driving_schools) }
    it { should have_many(:driving_schools).through(:student_driving_schools) }
  end
end
