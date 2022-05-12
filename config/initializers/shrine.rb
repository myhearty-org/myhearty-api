# frozen_string_literal: true

require "shrine"
require "shrine/storage/s3"
require "shrine/storage/url"

s3_options = Rails.application.credentials.s3

Shrine.storages = {
  url: Shrine::Storage::Url.new,
  cache: Shrine::Storage::S3.new(prefix: "cache", upload_options: { acl: "public-read" }, **s3_options),
  store: Shrine::Storage::S3.new(prefix: "store", upload_options: { acl: "public-read" }, **s3_options)
}

Shrine.plugin :activerecord

Shrine.plugin :cached_attachment_data

Shrine.plugin :restore_cached_data

Shrine.plugin :presign_endpoint, presign_options: -> (request) {
  # Uppy will send the "filename" and "type" query parameters
  filename = request.params["filename"]
  type = request.params["type"]

  {
    content_disposition: ContentDisposition.inline(filename), # set download filename
    content_type: type, # set content type (defaults to "application/octet-stream")
    content_length_range: 0..(10 * 1024 * 1024) # limit upload size to 10 MB
  }
}

# delay promoting and deleting files to a background job
Shrine.plugin :backgrounding

Shrine::Attacher.promote_block { Attachment::PromoteJob.perform_later(record, name.to_s, file_data) }

Shrine::Attacher.destroy_block { Attachment::DestroyJob.perform_later(data) }
