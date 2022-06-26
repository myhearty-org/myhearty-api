# frozen_string_literal: true

module Attachment
  class DestroyJob
    include Sidekiq::Job

    def perform(attacher_class, data)
      attacher_class = Object.const_get(attacher_class)

      attacher = attacher_class.from_data(data)
      attacher.destroy
    end
  end
end
