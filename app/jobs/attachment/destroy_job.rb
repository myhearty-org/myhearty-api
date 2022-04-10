# frozen_string_literal: true

module Attachment
  class DestroyJob < ApplicationJob
    def perform(data)
      attacher = Shrine::Attacher.from_data(data)
      attacher.destroy
    end
  end
end
