# frozen_string_literal: true

class Organization < ApplicationRecord
  include ImageUploader::Attachment(:avatar)
  include ImageUploader::Attachment(:image)
  include Charitable
  include FriendlyId
  include UrlHelper

  friendly_id :name, use: :slugged
  geocoded_by :location

  after_commit :index_document, on: [:create, :update]

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
    should_be_geocoded = location.present? && saved_change_to_location?

    Typesense::IndexOrganizationJob.perform_async(id, should_be_geocoded)
  end
end
