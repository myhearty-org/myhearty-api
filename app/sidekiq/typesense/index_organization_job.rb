# frozen_string_literal: true

module Typesense
  class IndexOrganizationJob
    include Sidekiq::Job

    def perform(id, should_be_geocoded)
      organization = Organization.find(id)

      if should_be_geocoded
        latitude, longitude = organization.geocode
        organization.update_columns(latitude: latitude, longitude: longitude)
      end

      document = {
        id: organization.id.to_s,
        name: organization.name,
        categories: organization.charity_causes_names,
        about_us: organization.about_us.truncate(120, separator: " "),
        location: organization.location,
        coordinates: [organization.latitude.to_f, organization.longitude.to_f],
        charity: organization.charity,
        page_url: organization.page_url,
        image_url: organization.image_url
      }

      TypesenseClient.collections["organizations"].documents.upsert(document)
    end
  end
end
