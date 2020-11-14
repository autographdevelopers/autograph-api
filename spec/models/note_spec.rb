describe Note do
  context 'Validations' do
    let(:title) { 'test-title' }
    let(:body) { 'test-body' }
    let(:context) { :lesson_note_from_instructor }
    let(:datetime) { Time.current }
    let(:driving_school) { create(:driving_school, status: :active) }
    let(:notable) { create(:driving_lesson, driving_school: driving_school) }

    subject { build(:note, notable: notable, title: title, body: body, context: context, datetime: datetime, driving_school: driving_school) }

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
      context 'when context is blank' do
        let(:context) { '' }

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end

        it 'yields proper error message' do
          subject.validate
          expect(subject.errors.full_messages).to eq ["Context can't be blank"]
        end
      end
    end

    context 'with invalid params' do
      context 'when notable is blank' do
        let(:notable) { nil }

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end

        it 'yields proper error message' do
          subject.validate
          expect(subject.errors.full_messages).to eq ["Notable must exist"]
        end
      end
    end

    context 'with invalid params' do
      context 'when notable is invalid' do
        let(:notable) { create(:color) }

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end

        it 'yields proper error message' do
          subject.validate
          expect(subject.errors.full_messages).to eq ["Notable type is not included in the list", "Context is not included in the list"]
        end
      end
    end
  end
end
