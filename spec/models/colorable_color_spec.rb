require 'rails_helper'

RSpec.describe ColorableColor, type: :model do
  let(:employee) { create(:employee) }

  let(:driving_school) { create(:driving_school, status: :active) }

  let!(:employee_driving_school) do
    create(:employee_driving_school,
           employee: employee,
           driving_school: driving_school,
           status: :active)
  end

  let(:colorable) { employee_driving_school }
  let(:hex_val) { '#fff' }
  let(:application) { :avatar_placeholder }

  let(:colorable_color) { build(:colorable_color, colorable: colorable, hex_val: hex_val, application: application) }

  context 'Validations' do
    context 'when params are valid' do
      it 'is valid' do
        expect(colorable_color).to be_valid
      end
    end

    context 'when colorable is blank' do
      let(:colorable) { nil }

      it 'is NOT valid' do
        expect(colorable_color).not_to be_valid
      end

      it 'yields proper error message' do
        colorable_color.validate
        expect(colorable_color.errors.full_messages).to eq ["Colorable must exist"]
      end
    end

    context 'when application is blank' do
      let(:application) { nil }

      it 'is NOT valid' do
        expect(colorable_color).not_to be_valid
      end

      it 'yields proper error message' do
        colorable_color.validate
        expect(colorable_color.errors.full_messages).to eq ["Application can't be blank"]
      end
    end

    context 'when hex_val is blank' do
      let(:hex_val) { nil }

      it 'is NOT valid' do
        expect(colorable_color).not_to be_valid
      end

      it 'yields proper error message' do
        colorable_color.validate
        expect(colorable_color.errors.full_messages).to eq ["Hex val can't be blank"]
      end
    end


    context 'when colorable_type in invalid' do
      let(:colorable) { create(:color) }


      it 'is NOT valid' do
        expect(colorable_color).not_to be_valid
      end

      it 'yields proper error message' do
        colorable_color.validate
        expect(colorable_color.errors.full_messages).to eq ["Colorable type is not included in the list"]
      end
    end

    context 'when record violate unique constraint' do
      let!(:colorable_color_dup) { create(:colorable_color, colorable: colorable, hex_val: hex_val, application: application) }


      it 'is NOT valid' do
        expect(colorable_color).not_to be_valid
      end

      it 'yields proper error message' do
        colorable_color.validate
        expect(colorable_color.errors.full_messages).to eq ["Hex val has already been taken"]
      end

      it 'has proper uniq constraint in place' do
        expect { colorable_color.save!(validate: false) }.to raise_exception { ActiveRecord::RecordNotUnique }
      end
    end
  end
end
