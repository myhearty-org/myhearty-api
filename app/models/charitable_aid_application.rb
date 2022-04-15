# frozen_string_literal: true

class CharitableAidApplication < ApplicationRecord
  before_save :set_status_updated_at

  belongs_to :charitable_aid
  belongs_to :receiver, class_name: "User"

  enum status: %i[pending approved rejected]

  validates :charitable_aid, presence: true, if: :charitable_aid_id_changed?
  validates :receiver, presence: true, if: :receiver_id_changed?
  validates :charitable_aid_id, uniqueness: { scope: :receiver_id },
                                if: -> { receiver_id_changed? || charitable_aid_id_changed? }
  validates :status, allow_nil: true, inclusion: { in: statuses.keys }

  delegate :organization, to: :charitable_aid

  scope :pending, -> { where(status: :pending) }
  scope :approved, -> { where(status: :approved) }
  scope :rejected, -> { where(status: :rejected) }

  counter_culture :charitable_aid,
                  column_name: ->(application) { application.approved? ? :receiver_count : nil },
                  column_names: { approved => :receiver_count },
                  touch: true
  after_update :index_receiver_count, if: :saved_change_to_status?

  def application_processed?
    !pending?
  end

  private

  def set_status_updated_at
    self.status_updated_at = Time.current if status_changed? || status_updated_at.nil?
  end

  def index_receiver_count
    reload_charitable_aid

    TypesenseClient.collections["charitable_aids"]
                   .documents[charitable_aid.id]
                   .update({ receiver_count: charitable_aid.receiver_count })
  end
end
