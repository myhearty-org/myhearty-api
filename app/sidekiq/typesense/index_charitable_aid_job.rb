# frozen_string_literal: true

module Typesense
  class IndexCharitableAidJob
    include Sidekiq::Job

    def perform(id, should_be_geocoded)
      charitable_aid = CharitableAid.find(id)

      if should_be_geocoded
        latitude, longitude = charitable_aid.geocode
        charitable_aid.update_columns(latitude: latitude, longitude: longitude)
      end

      document = {
        id: charitable_aid.id.to_s,
        name: charitable_aid.name,
        categories: charitable_aid.charity_causes_names,
        openings: charitable_aid.openings,
        receiver_count: charitable_aid.receiver_count,
        organization: charitable_aid.organization.name,
        application_deadline: charitable_aid.application_deadline.to_i,
        location: charitable_aid.location,
        coordinates: [charitable_aid.latitude.to_f, charitable_aid.longitude.to_f],
        page_url: charitable_aid.page_url,
        image_url: charitable_aid.image_url
      }

      TypesenseClient.collections["charitable_aids"].documents.upsert(document)
    end
  end
end
