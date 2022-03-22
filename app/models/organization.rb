# frozen_string_literal: true

class Organization < ApplicationRecord
  validates :name, presence: true, length: { maximum: 63 }
  validates :location, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 63 }, if: :email_changed?
  validates :contact_no, presence: true, length: { maximum: 20 }
  validates :website_url, allow_blank: true, url: true, uniqueness: { case_sensitive: false }, if: :website_url_changed?
  validates :facebook_url, allow_blank: true, url: true, if: :facebook_url_changed?
  validates :youtube_url, allow_blank: true, url: true, if: :youtube_url_changed?
  validates :person_in_charge_name, presence: true, length: { maximum: 63 }
  validates :video_url, allow_blank: true, url: true, if: :video_url_changed?
  validates :about_us, presence: true
  validates :is_charity, inclusion: [true, false]
  validates :is_charity, exclusion: [nil]
end
