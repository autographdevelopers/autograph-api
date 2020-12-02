require 'rails_helper'

RSpec.describe Color, type: :model do
  let(:hex_val) { '#fff' }
  let(:application) { :general }
  let(:palette_name) { 'IOS color palette' }

  let(:color) { build(:color, hex_val: hex_val, application: application, palette_name: palette_name) }

  context 'Validations' do
    context 'when params are valid' do
      it 'is valid' do
        expect(color).to be_valid
      end
    end

    context 'when palette_name is blank' do
      let(:palette_name) { nil }

      it 'is NOT valid' do
        expect(color).not_to be_valid
      end

      it 'yields proper error message' do
        color.validate
        expect(color.errors.full_messages).to eq ["Palette name can't be blank"]
      end
    end

    context 'when application is blank' do
      let(:application) { nil }

      it 'is NOT valid' do
        expect(color).not_to be_valid
      end

      it 'yields proper error message' do
        color.validate
        expect(color.errors.full_messages).to eq ["Application can't be blank"]
      end
    end

    context 'when application is blank' do
      let(:hex_val) { nil }

      it 'is NOT valid' do
        expect(color).not_to be_valid
      end

      it 'yields proper error message' do
        color.validate
        expect(color.errors.full_messages).to eq ["Hex val can't be blank"]
      end
    end
  end
end
