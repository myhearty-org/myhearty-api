# frozen_string_literal: true

class User < ApplicationRecord
  pay_customer

  has_many :identities, dependent: :delete_all
  has_many :donations
  has_many :payments

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable, :omniauthable,
         omniauth_providers: Identity::PROVIDERS
end
