# frozen_string_literal: true

class Identity < ApplicationRecord
  PROVIDERS = %w[
    facebook
    google_ouath2
  ].freeze

  belongs_to :user

  validates :provider, :uid, presence: true
  validates :provider, inclusion: { in: PROVIDERS }
  validates :uid, uniqueness: { scope: :provider },
                  if: -> { uid_changed? || provider_changed? }
  validates :user_id, uniqueness: { scope: :provider },
                      if: -> { user_id_changed? || provider_changed? }

  scope :with_provider_and_uid, ->(provider, uid) { where(provider: provider, uid: uid) }
end
