# frozen_string_literal: true

module Api
  module V0
    class CharitableAidsController < ApiController
      before_action :authenticate_member!, only: %i[create update destroy]

      def index
        if params.key?(:organization_id)
          @charitable_aids = paginate CharitableAid.where(organization_id: params[:organization_id])
                                                   .includes([:charity_causes, :organization])
                                                   .order(created_at: :desc)
        else
          @charitable_aids = paginate CharitableAid.all
                                                   .includes([:charity_causes, :organization])
                                                   .order(created_at: :desc)
        end
      end

      def show
        @charitable_aid = CharitableAid.find(params[:id])
      end

      def create
        result = CharitableAids::CreateService.call(current_member, charitable_aid_params)
        @charitable_aid = result.record

        if result.success?
          render :show, status: :created
        else
          render_error(result.json, result.http_status)
        end
      end

      def update
        @charitable_aid = CharitableAid.find(params[:id])
        result = CharitableAids::UpdateService.call(current_member, @charitable_aid, charitable_aid_params)

        if result.success?
          render :show, status: :ok
        else
          render_error(result.json, result.http_status)
        end
      end

      def destroy
        result = CharitableAids::DestroyService.call(current_member, params[:id])

        if result.success?
          head :no_content
        else
          render_error(result.json, result.http_status)
        end
      end

      private

      def charitable_aid_params
        charitable_aid_params = params.require(:charitable_aid).permit(charitable_aid_params_attributes)
        charitable_aid_params.merge!(categories_params)
        charitable_aid_params.merge!(image_params)
      end

      def charitable_aid_params_attributes
        %i[
          name
          openings
          location
          about_aid
          youtube_url
          application_deadline
          published
          approval_email_body
        ]
      end

      def categories_params
        params.slice(:categories).permit(categories: [])
      end

      def image_params
        params.slice(:image).permit(:image)
      end
    end
  end
end
