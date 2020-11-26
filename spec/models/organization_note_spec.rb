describe OrganizationNote do
  context 'Validations' do
    let(:title) { 'test-title' }
    let(:body) { 'test-body' }
    let(:datetime) { Time.current }
    let(:driving_school) { create(:driving_school, status: :active) }

    subject {
      build(:organization_note,
        title: title,
        body: body,
        datetime: datetime,
        driving_school: driving_school
      )
    }

    context 'with valid params' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'with invalid params' do
      context 'when title is blank' do
        let(:title) { '' }

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end

        it 'yields proper error message' do
          subject.validate
          expect(subject.errors.full_messages).to eq ["Title can't be blank"]
        end
      end
    end

    context 'with invalid params' do
      context 'when driving_school is blank' do
        let(:driving_school) { nil }

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end

        it 'yields proper error message' do
          subject.validate
          expect(subject.errors.full_messages).to eq ["Driving school must exist"]
        end
      end
    end
  end
end
