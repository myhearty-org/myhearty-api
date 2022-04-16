# frozen_string_literal: true

module Typesense
  class UpdateVolunteerCountJob
    include Sidekiq::Job

    def perform(id)
      volunteer_application = VolunteerApplication.find(id)
      volunteer_event = volunteer_application.volunteer_event

      TypesenseClient.collections["volunteer_events"]
                     .documents[volunteer_event.id]
                     .update({ volunteer_count: volunteer_event.volunteer_count })
    end
  end
end
