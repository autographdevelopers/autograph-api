# frozen_string_literal: true

json.pagination do
  json.is_more (!collection.last_page? && !collection.out_of_range?)
  json.total_pages collection.total_pages
  json.total_count collection.total_count
end
