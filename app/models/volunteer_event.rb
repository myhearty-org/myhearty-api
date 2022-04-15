# frozen_string_literal: true

class VolunteerEvent < ApplicationRecord
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

  has_many :volunteer_applications
  has_many :volunteers, through: :volunteer_applications

  attribute :published, :boolean, default: false

  validates :organization, presence: true, if: :organization_id_changed?
  validates :name, presence: true, length: { maximum: 255 }
  validates :slug, presence: true
  validates :openings, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }
  validates :volunteer_count, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :volunteer_count_less_than_openings
  validates :location, allow_blank: true, length: { maximum: 255 }
  validates :youtube_url, allow_blank: true, url: true
  validates_datetime :start_datetime, allow_nil: true, ignore_usec: true,
                                      after: :time_current, after_message: "must be after current datetime",
                                      if: :start_datetime_changed?
  validates_datetime :end_datetime, allow_nil: true, ignore_usec: true,
                                    after: :start_datetime, after_message: "must be after start datetime"
  validates_datetime :application_deadline, allow_nil: true, ignore_usec: true,
                                            after: :time_current, after_message: "must be after current datetime",
                                            before: :start_datetime, before_message: "must be before start datetime",
                                            if: -> { application_deadline_changed? || start_datetime_changed? }
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }
  validates_presence_of :openings, :location, :about_event, :start_datetime, :end_datetime, :application_deadline, if: :published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[published],
                                           error_code: :not_allowed_to_update_after_published,
                                           if: :already_published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[openings location start_datetime end_datetime application_deadline],
                                           error_code: :not_allowed_to_update_after_application_deadline,
                                           if: -> { already_published? && deadline_exceeded(:application_deadline) }

  private

  def slug_candidates
    [:name, [:name, :organization_id]]
  end

  def volunteer_count_less_than_openings
    return true if volunteer_count.nil? || openings.nil?

    errors.add(:volunteer_count, "must be less than total openings") if volunteer_count > openings
  end

  def index_document
    document = {
      id: id.to_s,
      name: name,
      categories: charity_causes_names,
      openings: openings,
      volunteer_count: volunteer_count,
      organization: organization.name,
      start_datetime: start_datetime.to_i,
      end_datetime: end_datetime.to_i,
      location: [latitude.to_f, longitude.to_f],
      url: url,
      image_url: image_url
    }

    TypesenseClient.collections["volunteer_events"].documents.upsert(document)
  end
end
