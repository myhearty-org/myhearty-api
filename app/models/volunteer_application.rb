# frozen_string_literal: true

class VolunteerApplication < ApplicationRecord
  belongs_to :volunteer_event
  belongs_to :volunteer, class_name: "User"

  enum status: %i[pending confirmed rejected]
  enum attendance: %i[absent present]

  validates :volunteer_event, presence: true
  validates :volunteer, presence: true
  validates :volunteer_event_id, uniqueness: { scope: :volunteer_id },
                                 if: -> { volunteer_id_changed? || volunteer_event_id_changed? }
  validates :status, allow_nil: true, inclusion: { in: statuses.keys }
  validates :attendance, allow_nil: true, inclusion: { in: attendances.keys }

  before_save :set_status_updated_at
  before_save :set_attendance_updated_at

  def set_status_updated_at
    self.status_updated_at = Time.current if status_changed? || status_updated_at.nil?
  end

  def set_attendance_updated_at
    self.attendance_updated_at = Time.current if attendance_changed? || attendance_updated_at.nil?
  end
end