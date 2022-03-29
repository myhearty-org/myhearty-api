# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :organization

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :lockable,
         :timeoutable, :trackable

  attribute :admin, :boolean, default: false

  validates :organization, presence: true, if: :organization_id_changed?

  scope :admin, -> { where(admin: true) }
end
