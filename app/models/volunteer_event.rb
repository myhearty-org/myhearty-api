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

  after_commit :index_document, on: [:create, :update], if: :published?

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
  validate :start_datetime_must_be_after_current_datetime, if: -> { start_datetime_changed? || (published_changed? && published?) }
  validate :end_datetime_must_be_after_start_datetime
  validate :application_deadline_must_be_after_current_datetime, if: -> { application_deadline_changed? || (published_changed? && published?) }
  validate :application_deadline_must_be_before_start_datetime
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }
  validates_presence_of :openings, :location, :about_event, :start_datetime, :end_datetime, :application_deadline, if: :published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[published],
                                           error_code: :not_allowed_to_update_after_published,
                                           if: :already_published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[openings location start_datetime end_datetime application_deadline],
                                           error_code: :not_allowed_to_update_after_application_deadline,
                                           if: -> { already_published? && deadline_exceeded(:application_deadline) }

  def index_document
    Typesense::IndexVolunteerEventJob.perform_async(id, should_be_geocoded?)
  end

  def should_be_geocoded?
    (location.present? && saved_change_to_location?) || (location.present? && (latitude.blank? || longitude.blank?))
  end

  def application_closed?
    deadline_exceeded? || volunteer_count_exceeded?
  end

  def deadline_exceeded?
    Time.current > application_deadline
  end

  def volunteer_count_exceeded?
    volunteer_count >= openings
  end

  private

  def slug_candidates
    [:name, [:name, :organization_id]]
  end

  def volunteer_count_less_than_openings
    return true if volunteer_count.nil? || openings.nil?

    errors.add(:volunteer_count, :must_be_less_than_openings) if volunteer_count > openings
  end

  def start_datetime_must_be_after_current_datetime
    return if start_datetime.blank?

    errors.add(:start_datetime, :must_be_after_current_datetime) if start_datetime.to_i < Time.current.to_i
  end

  def end_datetime_must_be_after_start_datetime
    return if start_datetime.blank? || end_datetime.blank?

    errors.add(:end_datetime, :must_be_after_start_datetime) if end_datetime.to_i <= start_datetime.to_i
  end

  def application_deadline_must_be_after_current_datetime
    return if application_deadline.blank?

    errors.add(:application_deadline, :must_be_after_current_datetime) if application_deadline.to_i < Time.current.to_i
  end

  def application_deadline_must_be_before_start_datetime
    return if application_deadline.blank? || start_datetime.blank?

    errors.add(:application_deadline, :must_be_before_start_datetime) if application_deadline.to_i >= start_datetime.to_i
  end
end
