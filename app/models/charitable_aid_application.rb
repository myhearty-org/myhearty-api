# frozen_string_literal: true

class CharitableAidApplication < ApplicationRecord
  belongs_to :charitable_aid
  belongs_to :receiver, class_name: "User"

  enum status: %i[pending approved rejected]

  validates :charitable_aid, presence: true, if: :charitable_aid_id_changed?
  validates :receiver, presence: true, if: :receiver_id_changed?
  validates :charitable_aid_id, uniqueness: { scope: :receiver_id },
                                if: -> { receiver_id_changed? || charitable_aid_id_changed? }
  validates :status, allow_nil: true, inclusion: { in: statuses.keys }

  before_save :set_status_updated_at

  def set_status_updated_at
    self.status_updated_at = Time.current if status_changed? || status_updated_at.nil?
  end

  delegate :organization, to: :charitable_aid
end
