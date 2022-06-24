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

  after_commit :index_document, on: [:create, :update], if: :published?

  belongs_to :organization

  has_many :charitable_aid_applications
  has_many :receivers, through: :charitable_aid_applications

  attribute :published, :boolean, default: false

  validates :organization, presence: true, if: :organization_id_changed?
  validates :name, presence: true, length: { maximum: 255 }
  validates :slug, presence: true
  validates :openings, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }
  validates :receiver_count, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :openings_more_than_receiver_count
  validates :location, allow_blank: true, length: { maximum: 255 }
  validates :youtube_url, allow_blank: true, url: true
  validate :application_deadline_must_be_after_current_datetime, if: -> { application_deadline_changed? || (published_changed? && published?) }
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }
  validates_presence_of :openings, :location, :about_aid, :application_deadline, if: :published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[name published],
                                           error_code: :not_allowed_to_update_after_published,
                                           if: :already_published?
  validates_with UnallowedParamsValidator, unallowed_params: %i[openings location application_deadline],
                                           error_code: :not_allowed_to_update_after_application_deadline,
                                           if: -> { already_published? && deadline_exceeded(:application_deadline) }

  def index_document
    Typesense::IndexCharitableAidJob.perform_async(id, should_be_geocoded?)
  end

  def should_be_geocoded?
    (location.present? && saved_change_to_location?) || (location.present? && (latitude.blank? || longitude.blank?))
  end

  def application_closed?
    deadline_exceeded? || receiver_count_exceeded?
  end

  alias_method :application_closed, :application_closed?

  def deadline_exceeded?
    return false if application_deadline.nil?

    Time.current > application_deadline
  end

  def receiver_count_exceeded?
    return false if openings.nil?

    receiver_count >= openings
  end

  private

  def slug_candidates
    [:name, [:name, :organization_id]]
  end

  def openings_more_than_receiver_count
    return true if openings.nil? || receiver_count.nil?

    errors.add(:openings, :must_be_more_than_receiver_count) if openings < receiver_count
  end

  def application_deadline_must_be_after_current_datetime
    return if application_deadline.blank?

    errors.add(:application_deadline, :must_be_after_current_datetime) if application_deadline.to_i < Time.current.to_i
  end
end
