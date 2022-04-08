# frozen_string_literal: true

module Members
  class CreateService < BaseService
    def initialize(organization, params, admin: false)
      @organization = organization
      @params = params.dup
      @admin = admin
    end

    def call
      build_member_params
      member = organization.members.new(params)

      if member.save
        success(record: member)
      else
        error_invalid_params(member)
      end
    end

    private

    attr_reader :organization, :params, :admin

    def build_member_params
      params[:password_confirmation] = params[:password]
      params[:admin] = admin
      params[:remember_created_at] = Time.current
    end
  end
end
