# frozen_string_literal: true

module Api
  module V0
    module Users
      class CharitableAidApplicationsController < ApiController
        def index
          @charitable_aid_applications = current_user.charitable_aid_applications
        end
      end
    end
  end
end
