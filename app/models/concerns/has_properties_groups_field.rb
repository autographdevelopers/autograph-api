# frozen_string_literal: true

module HasPropertiesGroupsField
  module Model
    extend ActiveSupport::Concern

    included do
      class_attribute :groups_properties_columns
      self.groups_properties_columns = %i[properties_groups]
      validate :properties_groups_json_schema

      PROPERTIES_GROUPS_JSON_SCHEMA = {
        'type' => 'array',
        'items' => {
          'type' => 'object',
          'properties' => {
            'title' => { 'type' => "string" },
            'order' => { 'type' => 'number'},
            'data' => {
              'type' => 'array',
              'items' => {
                'type' => 'object',
                'properties' => {
                  'propertyName' => { 'type' => "string" },
                  'propertyValue' => { 'type' => "string" },
                  'order' => { 'type' => 'number'},
                },
              }
            }
          }
        }
      }

      private

      def properties_groups_json_schema
        self.class.groups_properties_columns.each do |jsonb_column_name|
          next if JSON::Validator.validate(PROPERTIES_GROUPS_JSON_SCHEMA, self[jsonb_column_name], strict: true)
          errors.add(jsonb_column_name, 'Invalid properties group schema')
        end
      end
    end
  end
end

