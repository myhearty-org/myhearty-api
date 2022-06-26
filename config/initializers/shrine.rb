# frozen_string_literal: true

require "shrine"
require "shrine/storage/s3"
require "shrine/storage/url"

s3_options = Rails.application.credentials.s3

Shrine.storages = {
  url: Shrine::Storage::Url.new,
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(**s3_options)
}

Shrine.plugin :url_options, cache: { host: "https://assets.myhearty.my", public: true },
                            store: { host: "https://assets.myhearty.my", public: true }

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

Shrine::Attacher.promote_block do
  Attachment::PromoteJob.perform_async(self.class.name, record.class.name, record.id, name, file_data)
end

Shrine::Attacher.destroy_block do
  Attachment::DestroyJob.perform_async(self.class.name, data)
end
