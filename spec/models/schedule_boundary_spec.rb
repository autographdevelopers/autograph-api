describe ScheduleBoundary do
  context 'enumerators' do
    it { should define_enum_for(:weekday).with([:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]) }
  end

  context 'relations' do
    it { should belong_to(:driving_school) }
  end

  context 'validations' do
    it { should validate_presence_of(:weekday) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }
  end

  context 'instance methods' do
    context '#valid_time?' do
      let(:valid_time?) { ->(time) { ScheduleBoundary.new.send(:valid_time?, time) } }

      it 'accepts following values: 2017-11-30 19:30:22, 2018-11-30 19:00:22, 2018-01-30 24:00:22' do
        expect(valid_time?.call('2017-11-30 19:30:22')).to be true
        expect(valid_time?.call('2018-11-30 19:00:22')).to be true
        expect(valid_time?.call('2018-01-30 24:00:00')).to be true
      end

      it 'does NOT accept following values: 2017-11-30 19:31:22, 2018-11-30 19:01:22, 2018-01-30 23:50:22' do
        expect(valid_time?.call('2017-11-30 19:31:22')).to be false
        expect(valid_time?.call('2018-11-30 19:01:22')).to be false
        expect(valid_time?.call('2018-01-30 23:50:22')).to be false
      end
    end
  end
end
