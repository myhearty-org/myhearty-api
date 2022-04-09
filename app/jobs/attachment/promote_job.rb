# frozen_string_literal: true

module Attachment
  class PromoteJob < ApplicationJob
    def perform(record, name, file_data)
      attacher = Shrine::Attacher.retrieve(model: record, name: name, file: file_data)
      attacher.atomic_promote
    rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound
      # attachment has changed or the record has been deleted, nothing to do
    end
  end
end
