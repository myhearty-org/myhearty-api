# frozen_string_literal: true

class User < ApplicationRecord
  include ImageUploader::Attachment(:avatar)

  has_many :identities, dependent: :delete_all
  has_many :donations, foreign_key: :donor_id
  has_many :payments
  has_many :volunteer_applications, foreign_key: :volunteer_id
  has_many :charitable_aid_applications, foreign_key: :receiver_id

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable, :omniauthable,
         omniauth_providers: Identity::PROVIDERS

  protected

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
