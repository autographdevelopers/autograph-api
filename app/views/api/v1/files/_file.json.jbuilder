# frozen_string_literal: true
#
json.id file.id
json.filename file.filename
json.size file.byte_size
json.content_type file.content_type
json.link_url Rails.application.routes.url_helpers.rails_blob_url(file)
json.download_url Rails.application.routes.url_helpers.rails_blob_url(file, disposition: "attachment")
