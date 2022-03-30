# frozen_string_literal: true

class FundraisingCampaign < ApplicationRecord
  include Charitable
  include RandomId

  self.random_id_prefix = "frcp"

  belongs_to :organization

  has_many :donations
  has_many :donors, through: :donations
  has_many :payments

  attribute :published, :boolean, default: false

  validates :organization, presence: true, if: :organization_id_changed?
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, allow_blank: true, url: true
  validates :target_amount, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_raised_amount, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :donor_count, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :location, allow_blank: true, length: { maximum: 255 }
  validates :main_image, allow_blank: true, url: true
  validates :youtube_url, allow_blank: true, url: true
  validates_datetime :start_datetime, allow_nil: true, ignore_usec: true,
                                      on_or_after: :time_current, on_or_after_message: "must be after current datetime"
  validates_datetime :end_datetime, allow_nil: true, ignore_usec: true,
                                    after: :start_datetime, after_message: "must be after start datetime"
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }
end
