# frozen_string_literal: true

module FundraisingCampaigns
  class MetricsService < BaseService
    def initialize(fundraising_campaign, interval_start, interval_end)
      @fundraising_campaign = fundraising_campaign
      @interval_start = interval_start.to_i if interval_start.present?
      @interval_end = interval_end.to_i if interval_end.present?
    end

    def call
      if interval_start.nil? || interval_end.nil?
        set_interval
      elsif maximum_interval_exceeded?
        return error_maximum_interval
      end

      success(record: metrics)
    end

    private

    attr_reader :fundraising_campaign, :interval_start, :interval_end

    def set_interval
      if interval_start.nil? && interval_end.nil?
        @interval_end = [Time.current.to_i, fundraising_campaign.end_datetime.to_i].min
        @interval_start = [interval_end - 1.year.to_i, fundraising_campaign.start_datetime.to_i].max
      elsif interval_start.nil?
        @interval_end = [interval_end, fundraising_campaign.end_datetime.to_i].min
        @interval_start = [interval_end - 1.year.to_i, fundraising_campaign.start_datetime.to_i].max
      elsif interval_end.nil?
        @interval_start = [interval_start, fundraising_campaign.start_datetime.to_i].max
        @interval_end = [interval_start + 1.year.to_i, fundraising_campaign.end_datetime.to_i].min
      end
    end

    def maximum_interval_exceeded?
      interval_end - interval_start > 1.year.to_i
    end

    def error_maximum_interval
      error(
        json: { code: "donation_metrics_max_interval" },
        http_status: :unprocessable_entity
      )
    end

    def metrics
      to_data_array(day_grouped_data)
    end

    def day_grouped_data
      fundraising_campaign.donations.with_payment
                          .group_by_day(:completed_at,
                                        range: Time.at(interval_start).to_datetime..Time.at(interval_end).to_datetime,
                                        expand_range: true,
                                        format: "%s") # %s indicates Unix timestamp
                          .sum(:net_amount)
    end

    # Convert data into cumulative sum with the format:
    # [Unix timestamp, donation in RM], e.g., [1649433600, 95.76]
    def to_data_array(data)
      sum = 0

      data.map do |timestamp, donation_amount|
        sum += donation_amount
        [timestamp.to_i * 1000, sum.to_f / 100] # Convert timestamp from seconds to milliseconds
      end
    end
  end
end
