# frozen_string_literal: true

module Typesense
  class UpdateDonorCountJob
    include Sidekiq::Job

    def perform(id)
      payment = Payment.find(id)
      fundraising_campaign = payment.fundraising_campaign

      TypesenseClient.collections["fundraising_campaigns"]
                     .documents[fundraising_campaign.id]
                     .update({ donor_count: fundraising_campaign.donor_count })
    end
  end
end
