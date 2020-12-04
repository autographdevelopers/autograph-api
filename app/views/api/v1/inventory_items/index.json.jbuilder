json.results { json.array! @inventory_items, partial: 'api/v1/inventory_items/inventory_item', as: :inventory_item }
json.pagination { json.is_more (!@inventory_items.last_page? && !@inventory_items.out_of_range?) }
