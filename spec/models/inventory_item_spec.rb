describe InventoryItem do
  let(:name) { 'test' }
  let(:properties_groups) do
    [
      {
        title: 'Personal data',
        order: 1,
        data: [
          { propertyName: 'Name', propertyValue: 'john', order: 1 },
          { propertyName: 'Surname', propertyValue: 'doe', order: 2 },
        ]
      },
      {
        title: 'Location',
        order: 2,
        data: [
          { propertyName: 'City', propertyValue: 'New York', order: 1 },
          { propertyName: 'Address', propertyValue: 'Brooklyn', order: 2 }
        ]
      }
    ]
  end

  subject { build(:inventory_item, properties_groups: properties_groups, name: name) }

  context 'Validations' do
    context '#properties_groups' do
      context 'when holds an empty array' do
        let(:properties_groups) { [] }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'when holding non-empty array of sections that conform to json schema' do
        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'with unknown key in section node' do
        let!(:properties_groups) do
          [
            {
              title: 'Personal data',
              unknownKeyInSection1: 'test',
              order: 1,
              data: [
                { propertyName: 'Name', propertyValue: 'john', order: 1 },
                { propertyName: 'Surname', propertyValue: 'doe', order: 2 },
              ]
            },
            {
              title: 'Location',
              order: 2,
              data: [
                { propertyName: 'City', propertyValue: 'New York', order: 1 },
                { propertyName: 'Address', propertyValue: 'Brooklyn', order: 2 }
              ]
            }
          ]
        end

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end
      end

      context 'with unknown key in a property node' do
        let!(:properties_groups) do
          [
            {
              title: 'Personal data',
              order: 1,
              data: [
                { propertyName: 'Name', propertyValue: 'john', order: 1 },
                { propertyName: 'Surname', propertyValue: 'doe', order: 2 },
              ]
            },
            {
              title: 'Location',
              order: 2,
              data: [
                { propertyName: 'City', propertyValue: 'New York', order: 1, unknownKeyInSection1: 'test' },
                { propertyName: 'Address', propertyValue: 'Brooklyn', order: 2 }
              ]
            }
          ]
        end

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end
      end

      context 'without section order' do
        let!(:properties_groups) do
          [
            {
              title: 'Personal data',
              data: [
                { propertyName: 'Name', propertyValue: 'john', order: 1 },
                { propertyName: 'Surname', propertyValue: 'doe', order: 2 },
              ]
            },
            {
              title: 'Location',
              data: [
                { propertyName: 'City', propertyValue: 'New York', order: 1 },
                { propertyName: 'Address', propertyValue: 'Brooklyn', order: 2 }
              ]
            }
          ]
        end

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end
      end

      context 'without name order' do
        let(:name) { nil }

        it 'is NOT valid' do
          expect(subject).not_to be_valid
        end
      end
    end
  end
end