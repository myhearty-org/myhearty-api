# frozen_string_literal: true

class FundraisingCampaign < ApplicationRecord
  include ActiveModel::Validations
  include ImageUploader::Attachment(:image)
  include Charitable
  include Publishable
  include FriendlyId
  include UrlHelper
  include RandomId

  friendly_id :slug_candidates, use: :slugged
  random_id prefix: :frcp

  before_validation :set_start_datetime, if: -> { published_changed? && published? }
  after_commit :index_document, on: [:create, :update], if: :published?

  belongs_to :organization

  has_many :donations
  has_many :donors, -> { distinct }, through: :donations
  has_many :payments

  attribute :published, :boolean, default: false

  validates :organization, presence: true, if: :organization_id_changed?
  validates :name, presence: true, length: { maximum: 255 }
  validates :slug, presence: true
  validates :target_amount, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_raised_amount, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :donor_count, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :youtube_url, allow_blank: true, url: true
  validate :end_datetime_must_be_after_current_datetime, if: -> { end_datetime_changed? || (published_changed? && published?) }
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }
  validates_presence_of :target_amount, :about_campaign, :end_datetime, if: :published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[name target_amount end_datetime published],
                                           error_code: :not_allowed_to_update_after_published,
                                           if: :already_published?

  def index_document
    Typesense::IndexFundraisingCampaignJob.perform_async(id, first_time_published?)
  end

  def first_time_published?
    saved_change_to_published? && published?
  end

  def create_stripe_product
    Stripe::Product.create({
      id: fundraising_campaign_id,
      name: name,
      images: [image_url],
      url: page_url
    }, { stripe_account: organization.stripe_account_id })
  rescue Stripe::InvalidRequestError
  end

  def ended?
    end_datetime_exceeded? || target_amount_reached?
  end

  alias_method :ended, :ended?

  def end_datetime_exceeded?
    return false if end_datetime.nil?

    Time.current > end_datetime
  end

  def target_amount_reached?
    return false if target_amount.nil?

    total_raised_amount >= target_amount
  end

  private

  def slug_candidates
    [:name, [:name, :organization_id]]
  end

  def set_start_datetime
    self.start_datetime = Time.current
  end

  def end_datetime_must_be_after_current_datetime
    return if end_datetime.blank?

    errors.add(:end_datetime, :must_be_after_current_datetime) if end_datetime.to_i <= Time.current.to_i
  end
end
