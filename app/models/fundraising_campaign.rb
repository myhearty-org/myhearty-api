# frozen_string_literal: true

class FundraisingCampaign < ApplicationRecord
  include ImageUploader::Attachment(:image)
  include Charitable
  include RandomId

  random_id prefix: :frcp
  geocoded_by :location

  after_validation :geocode, if: -> { location.present? && location_changed? }

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
  validates :youtube_url, allow_blank: true, url: true
  validates_datetime :start_datetime, allow_nil: true, ignore_usec: true,
                                      on_or_after: :time_current, on_or_after_message: "must be after current datetime"
  validates_datetime :end_datetime, allow_nil: true, ignore_usec: true,
                                    after: :start_datetime, after_message: "must be after start datetime"
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }

  before_create :create_stripe_product, if: :published?
  before_update :create_stripe_product, if: -> { published_changed? && published? }

  private

  def create_stripe_product
    Stripe::Product.create({
      id: fundraising_campaign_id,
      name: name
    }, { stripe_account: organization.stripe_account_id })
  rescue Stripe::StripeError
    errors.add(:fundraising_campaign_id, :failed_to_create_stripe_product)
    throw(:abort)
  end
end
