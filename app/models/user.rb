# frozen_string_literal: true

class User < ApplicationRecord
  include ImageUploader::Attachment(:avatar)

  enum gender: %i[male female]

  has_many :identities, dependent: :delete_all
  has_many :donations, foreign_key: :donor_id
  has_many :payments
  has_many :volunteer_applications, foreign_key: :volunteer_id
  has_many :charitable_aid_applications, foreign_key: :receiver_id

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable, :omniauthable,
         omniauth_providers: Identity::PROVIDERS

  validates :name, allow_blank: true, length: { maximum: 63 }
  validates :contact_no, phone: true, allow_blank: true, length: { maximum: 20 }
  validates :address, allow_blank: true, length: { maximum: 255 }
  validate :birth_date_must_be_before_current_date
  validates :gender, allow_blank: true, inclusion: { in: genders.keys }

  protected

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def birth_date_must_be_before_current_date
    return if birth_date.blank?

    errors.add(:birth_date, :must_be_before_current_date) if birth_date.to_i >= Time.current.to_i
  end
end
