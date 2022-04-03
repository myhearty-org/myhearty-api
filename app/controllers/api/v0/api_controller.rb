# frozen_string_literal: true

module Api
  module V0
    class ApiController < ApplicationController
      protected

      def authenticate_organization_admin!
        return respond_401 unless authenticate_member! && current_member.admin?
      end
    end
  end
end
