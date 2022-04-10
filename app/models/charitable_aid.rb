# frozen_string_literal: true

class CharitableAid < ApplicationRecord
  include ImageUploader::Attachment(:image)
  include Charitable

  geocoded_by :location

  after_validation :geocode, if: -> { location.present? && location_changed? }

  belongs_to :organization

  has_many :charitable_aid_applications
  has_many :receivers, through: :charitable_aid_applications

  attribute :published, :boolean, default: false

  validates :organization, presence: true, if: :organization_id_changed?
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, allow_blank: true, url: true
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

  def receiver_count_less_than_openings
    return true if receiver_count.nil? || openings.nil?

    errors.add(:receiver_count, "must be less than total openings") if receiver_count > openings
  end
end
