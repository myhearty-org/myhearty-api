# frozen_string_literal: true

module FundraisingCampaigns
  class MetricsService < BaseService
    def initialize(fundraising_campaign, interval_start, interval_end)
      @fundraising_campaign = fundraising_campaign
      @interval_start = Time.at(interval_start.to_i).to_datetime if interval_start.present?
      @interval_end = Time.at(interval_end.to_i).to_datetime if interval_end.present?
    end

    def call
      metrics
    end

    private

    attr_reader :fundraising_campaign, :interval_start, :interval_end

    def metrics
      [to_data_array(day_grouped_data)]
    end

    def day_grouped_data
      fundraising_campaign.donations.with_payment
                          .group_by_day(:completed_at, range: interval_start..interval_end, expand_range: true, format: "%s") # %s indicates Unix timestamp
                          .sum(:net_amount)
    end

    # Convert data into cumulative sum with the format:
    # [Unix timestamp, donation in RM], e.g., [1649433600, 95.76]
    def to_data_array(data)
      sum = 0

      data.map do |timestamp, donation_amount|
        sum += donation_amount
        [timestamp.to_i, sum.to_f / 100]
      end
    end
  end
end
