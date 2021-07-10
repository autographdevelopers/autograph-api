json.results { json.array! @inventory_items, partial: 'api/v1/inventory_items/inventory_item', as: :inventory_item }
json.partial! 'api/v1/helper/pagination', locals: { collection: @inventory_items }
