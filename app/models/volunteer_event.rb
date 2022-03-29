# frozen_string_literal: true

class VolunteerEvent < ApplicationRecord
  belongs_to :organization

  has_many :volunteer_applications
  has_many :volunteers, through: :volunteer_applications

  attribute :published, :boolean, default: false

  validates :organization, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, allow_blank: true, url: true
  validates :openings, allow_nil: true, numericality: { only_integer: true, greater_than: 0 }
  validates :volunteer_count, allow_nil: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :volunteer_count_less_than_openings
  validates :location, allow_blank: true, length: { maximum: 255 }
  validates :main_image, allow_blank: true, url: true
  validates :youtube_url, allow_blank: true, url: true
  validates_datetime :start_datetime, allow_nil: true, ignore_usec: true,
                                      after: :time_current, after_message: "must be after current datetime"
  validates_datetime :end_datetime, allow_nil: true, ignore_usec: true,
                                    after: :start_datetime, after_message: "must be after start datetime"
  validates_datetime :sign_up_deadline, allow_nil: true, ignore_usec: true,
                                        after: :time_current, after_message: "must be after current datetime",
                                        before: :start_datetime, before_message: "must be before start datetime"
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }

  def volunteer_count_less_than_openings
    return true if volunteer_count.nil? || openings.nil?

    errors.add(:volunteer_count, "must be less than total openings") if volunteer_count > openings
  end
end
