# frozen_string_literal: true

module Api
  module V0
    module Users
      class VolunteerApplicationsController < ApiController
        before_action :authenticate_user!

        def index
          @volunteer_applications = current_user.volunteer_applications
        end
      end
    end
  end
end
