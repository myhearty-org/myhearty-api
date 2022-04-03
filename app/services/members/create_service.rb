# frozen_string_literal: true

module Members
  class CreateService < BaseService
    def initialize(params, organization, admin: false)
      @params = params.dup
      @organization = organization
      @admin = admin
    end

    def call
      build_member_params
      member = organization.members.new(params)
      member.save
      member
    end

    private

    attr_reader :params, :organization, :admin

    def build_member_params
      params[:password_confirmation] = params[:password]
      params[:admin] = admin
      params[:remember_created_at] = Time.current
    end
  end
end
