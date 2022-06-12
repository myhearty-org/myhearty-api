# frozen_string_literal: true

class Member < ApplicationRecord
  include ImageUploader::Attachment(:avatar)

  belongs_to :organization

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable

  attribute :admin, :boolean, default: false

  validates :organization, presence: true, if: :organization_id_changed?

  delegate :charity?, to: :organization

  scope :admin, -> { where(admin: true) }
  scope :not_admin, -> { where(admin: false) }

  protected

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
