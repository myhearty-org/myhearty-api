# frozen_string_literal: true

class CharitableAid < ApplicationRecord
  include ActiveModel::Validations
  include ImageUploader::Attachment(:image)
  include Charitable
  include Publishable
  include Deadlinable
  include FriendlyId
  include UrlHelper

  friendly_id :slug_candidates, use: :slugged
  geocoded_by :location

  after_validation :geocode, if: -> { location.present? && location_changed? }
  after_save :index_document, if: :published?

  belongs_to :organization

  has_many :charitable_aid_applications
  has_many :receivers, through: :charitable_aid_applications

  attribute :published, :boolean, default: false

  validates :organization, presence: true, if: :organization_id_changed?
  validates :name, presence: true, length: { maximum: 255 }
  validates :slug, presence: true
  validates :openings, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }
  validates :receiver_count, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :receiver_count_less_than_openings
  validates :location, allow_blank: true, length: { maximum: 255 }
  validates :youtube_url, allow_blank: true, url: true
  validates_datetime :application_deadline, allow_nil: true, ignore_usec: true,
                                            after: :time_current, after_message: "must be after current datetime",
                                            if: :application_deadline_changed?
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }
  validates_presence_of :openings, :location, :about_aid, :application_deadline, if: :published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[published],
                                           error_code: :not_allowed_to_update_after_published,
                                           if: :already_published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[openings location application_deadline],
                                           error_code: :not_allowed_to_update_after_application_deadline,
                                           if: -> { already_published? && deadline_exceeded(:application_deadline) }

  def application_closed?
    deadline_exceeded? || receiver_count_exceeded?
  end

  def deadline_exceeded?
    Time.current > application_deadline
  end

  def receiver_count_exceeded?
    receiver_count >= openings
  end

  private

  def slug_candidates
    [:name, [:name, :organization_id]]
  end

  def receiver_count_less_than_openings
    return true if receiver_count.nil? || openings.nil?

    errors.add(:receiver_count, "must be less than total openings") if receiver_count > openings
  end

  def index_document
    Typesense::IndexCharitableAidJob.perform_async(id)
  end
end
