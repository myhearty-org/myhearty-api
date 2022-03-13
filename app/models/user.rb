# frozen_string_literal: true

class User < ApplicationRecord
  has_many :identities, dependent: :delete_all

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable, :omniauthable,
         omniauth_providers: Identity::PROVIDERS
end
