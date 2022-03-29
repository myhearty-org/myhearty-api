# frozen_string_literal: true

class User < ApplicationRecord
  pay_customer

  has_many :identities, dependent: :delete_all
  has_many :donations, foreign_key: :donor_id
  has_many :payments
  has_many :volunteer_applications, foreign_key: :volunteer_id
  has_many :charitable_aid_applications, foreign_key: :receiver_id

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable, :omniauthable,
         omniauth_providers: Identity::PROVIDERS
end
