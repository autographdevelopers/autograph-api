FactoryBot.define do
  factory :inventory_item do
    name { 'Item' }
    description { 'Desc' }
    properties_groups do
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
    driving_school
    association :author, factory: :employee
  end
end
