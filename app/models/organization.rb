# frozen_string_literal: true

class Organization < ApplicationRecord
  include ImageUploader::Attachment(:avatar)
  include ImageUploader::Attachment(:image)
  include Charitable
  include FriendlyId
  include UrlHelper

  friendly_id :name, use: :slugged
  geocoded_by :location

  after_validation :geocode, if: -> { location.present? && location_changed? }
  after_save :index_document

  has_many :members, dependent: :delete_all
  has_many :fundraising_campaigns, dependent: :delete_all
  has_many :volunteer_events, dependent: :delete_all
  has_many :charitable_aids, dependent: :delete_all

  attribute :charity, :boolean, default: false

  validates :name, presence: true, length: { maximum: 63 }
  validates :slug, presence: true
  validates :location, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 63 }, if: :email_changed?
  validates :contact_no, presence: true, length: { maximum: 20 }
  validates :website_url, allow_blank: true, url: true, uniqueness: { case_sensitive: false }, if: :website_url_changed?
  validates :facebook_url, allow_blank: true, url: true
  validates :youtube_url, allow_blank: true, url: true
  validates :person_in_charge_name, presence: true, length: { maximum: 63 }
  validates :video_url, allow_blank: true, url: true
  validates :about_us, presence: true
  validates :charity, inclusion: [true, false]
  validates :charity, exclusion: [nil]

  scope :charity, -> { where(charity: true) }

  def admins
    members.admin
  end

  private

  def index_document
    document = {
      id: id.to_s,
      name: name,
      categories: charity_causes_names,
      about_us: about_us.truncate(120, separator: " "),
      location: [latitude.to_f, longitude.to_f],
      charity: charity,
      page_url: page_url,
      image_url: image_url
    }

    TypesenseClient.collections["organizations"].documents.upsert(document)
  end
end
