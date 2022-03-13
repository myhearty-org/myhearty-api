# frozen_string_literal: true

module Oauth
  class LinkIdentityService < BaseService
    def initialize(current_user, auth_hash)
      @current_user = current_user
      @auth_hash = auth_hash
      super
    end

    def call
      link_identity
    end

    private

    attr_reader :current_user, :auth_hash

    def link_identity
      return { status: :identity_exists } if linked_before?

      if identity.save
        { status: :identity_linked }
      else
        { status: :identity_failure, errors: identity.errors.full_messaages.to_sentence }
      end
    end

    def linked_before?
      !identity.new_record?
    end

    def identity
      @identity ||= current_user.identities
                                .with_provider_and_uid(provider, uid)
                                .first_or_initialize
    end

    def provider
      @provider ||= auth_hash.provider
    end

    def uid
      @uid ||= auth_hash.uid
    end
  end
end
