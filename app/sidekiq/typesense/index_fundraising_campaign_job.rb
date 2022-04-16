# frozen_string_literal: true

module Typesense
  class IndexFundraisingCampaignJob
    include Sidekiq::Job

    def perform(id)
      fundraising_campaign = FundraisingCampaign.find(id)

      document = {
        id: fundraising_campaign.id.to_s,
        name: fundraising_campaign.name,
        categories: fundraising_campaign.charity_causes_names,
        target_amount: fundraising_campaign.target_amount / 100.0,
        total_raised_amount: fundraising_campaign.total_raised_amount / 100.0,
        donor_count: fundraising_campaign.donor_count,
        organization: fundraising_campaign.organization.name,
        about_campaign: fundraising_campaign.about_campaign.truncate(120, separator: " "),
        page_url: fundraising_campaign.page_url,
        image_url: fundraising_campaign.image_url
      }

      TypesenseClient.collections["fundraising_campaigns"].documents.upsert(document)
    end
  end
end