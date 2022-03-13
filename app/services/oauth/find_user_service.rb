# frozen_string_literal: true

module Oauth
  class FindUserService < BaseService
    def initialize(current_user, auth_hash)
      @current_user = current_user
      @auth_hash = auth_hash
      super
    end

    def call
      find_user
    end

    private

    attr_reader :current_user, :auth_hash

    def find_user
      user = find_user_by_provider_and_uid

      if user.nil?
        user = build_new_user
        link_identity(user)
        return nil unless user.save
      end

      user
    end

    def find_user_by_provider_and_uid
      identity = Identity.find_by(provider: provider, uid: uid)
      identity&.user
    end

    def provider
      @provider ||= auth_hash.provider
    end

    def uid
      @uid ||= auth_hash.uid
    end

    def build_new_user
      User.new.tap do |user|
        user.assign_attributes(user_attributes)
        user.skip_confirmation!
      end
    end

    def user_attributes
      # username is only returned by facebook but not google_oauth2
      # hence, for google_oauth2, name will be used as username
      username = auth_hash.extra.raw_info.username.presence || auth_hash.info.name
      password = Devise.friendly_token[0, 20]

      {
        name: auth_hash.info.name,
        "#{provider}_username": username,
        avatar: auth_hash.info.image,
        email: auth_hash.info.email,
        password: password,
        password_confirmation: password,
        remember_created_at: Time.now.utc
      }
    end

    def link_identity(user)
      user.identities.build(identity_attributes)
    end

    def identity_attributes
      {
        provider: provider,
        uid: uid
      }
    end
  end
end
