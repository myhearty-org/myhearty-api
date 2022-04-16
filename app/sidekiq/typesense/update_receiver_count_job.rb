# frozen_string_literal: true

module Typesense
  class UpdateReceiverCountJob
    include Sidekiq::Job

    def perform(id)
      charitable_aid_application = CharitableAidApplication.find(id)
      charitable_aid = charitable_aid_application.charitable_aid

      TypesenseClient.collections["charitable_aids"]
                     .documents[charitable_aid.id]
                     .update({ receiver_count: charitable_aid.receiver_count })
    end
  end
end
