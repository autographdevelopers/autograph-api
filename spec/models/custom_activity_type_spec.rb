require 'rails_helper'

RSpec.describe CustomActivityType, type: :model do

  let(:name) { 'Car rental' }
  let(:message_template) { %(The "%{event_name}" has been registered by %{user_name}. Reporter note: %{note}) }
  let(:target_type) { InventoryItem.name }
  let(:notification_receivers) { :all_employees }
  let(:datetime_input_config) { :none }
  let(:text_note_input_config) { :none }

  subject do
    build(:custom_activity_type,
      name: name,
      message_template: message_template,
      target_type: target_type,
      notification_receivers: notification_receivers,
      datetime_input_config: datetime_input_config,
      text_note_input_config: text_note_input_config
    )
  end

  context 'Validations' do
    context 'with all valid params' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end
    context 'without name' do
      let(:name) { nil }

      it 'is NOT valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'without message_template' do
      let(:message_template) { nil }

      it 'is NOT valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'without target_type' do
      let(:target_type) { nil }

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'with not valid target_type' do
      let(:target_type) { 'Blablabla' }

      it 'is NOT valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'without notification_receivers' do
      let(:notification_receivers) { nil }

      it 'is valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'without datetime_input_config' do
      let(:datetime_input_config) { nil }

      it 'is valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'without text_note_input_config' do
      let(:text_note_input_config) { nil }

      it 'is valid' do
        expect(subject).not_to be_valid
      end
    end
  end
end
