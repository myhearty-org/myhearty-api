# frozen_string_literal: true

class FundraisingCampaign < ApplicationRecord
  belongs_to :organization

  has_many :donations

  attribute :published, :boolean, default: false

  validates :organization, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :url, allow_blank: true, url: true
  validates :target_amount, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :total_raised_amount, presence: true, numericality: { only_integer: true,
                                                                  greater_than_or_equal_to: 0,
                                                                  less_than_or_equal_to: :target_amount }
  validates :total_donors, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :location, length: { maximum: 255 }
  validates :main_image, allow_blank: true, url: true
  validates :youtube_url, allow_blank: true, url: true
  validates :end_datetime, comparison: { greater_than: :start_datetime }
  validates :published, inclusion: { in: [true, false] }
  validates :published, exclusion: { in: [nil] }
end
