# frozen_string_literal: true

module Typesense
  class IndexVolunteerEventJob
    include Sidekiq::Job

    def perform(id, should_be_geocoded)
      volunteer_event = VolunteerEvent.find(id)

      if should_be_geocoded
        latitude, longitude = volunteer_event.geocode
        volunteer_event.update_columns(latitude: latitude, longitude: longitude)
      end

      document = {
        id: volunteer_event.id.to_s,
        name: volunteer_event.name,
        categories: volunteer_event.charity_causes_names,
        openings: volunteer_event.openings,
        volunteer_count: volunteer_event.volunteer_count,
        organization: volunteer_event.organization.name,
        start_datetime: volunteer_event.start_datetime.to_i,
        end_datetime: volunteer_event.end_datetime.to_i,
        location: volunteer_event.location,
        coordinates: [volunteer_event.latitude.to_f, volunteer_event.longitude.to_f],
        page_url: volunteer_event.page_url,
        image_url: volunteer_event.image_url
      }

      TypesenseClient.collections["volunteer_events"].documents.upsert(document)
    end
  end
end
