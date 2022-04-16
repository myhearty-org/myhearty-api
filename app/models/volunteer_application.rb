# frozen_string_literal: true

class VolunteerApplication < ApplicationRecord
  before_save :set_status_updated_at
  before_save :set_attendance_updated_at

  belongs_to :volunteer_event
  belongs_to :volunteer, class_name: "User"

  enum status: %i[pending confirmed rejected]
  enum attendance: %i[absent present]

  validates :volunteer_event, presence: true, if: :volunteer_event_id_changed?
  validates :volunteer, presence: true, if: :volunteer_id_changed?
  validates :volunteer_event_id, uniqueness: { scope: :volunteer_id },
                                 if: -> { volunteer_id_changed? || volunteer_event_id_changed? }
  validates :status, allow_nil: true, inclusion: { in: statuses.keys }
  validates :attendance, allow_nil: true, inclusion: { in: attendances.keys }

  delegate :organization, to: :volunteer_event

  scope :pending, -> { where(status: :pending) }
  scope :confirmed, -> { where(status: :confirmed) }
  scope :rejected, -> { where(status: :rejected) }
  scope :absent, -> { where(attendance: :absent) }
  scope :present, -> { where(attendance: :present) }

  counter_culture :volunteer_event,
                  column_name: ->(application) { application.confirmed? ? :volunteer_count : nil },
                  column_names: { confirmed => :volunteer_count },
                  touch: true
  after_update :index_volunteer_count, if: :saved_change_to_status?

  def application_processed?
    !pending?
  end

  private

  def set_status_updated_at
    self.status_updated_at = Time.current if status_changed? || status_updated_at.nil?
  end

  def set_attendance_updated_at
    self.attendance_updated_at = Time.current if attendance_changed? || attendance_updated_at.nil?
  end

  def index_volunteer_count
    Typesense::UpdateVolunteerCountJob.perform_async(id)
  end
end
