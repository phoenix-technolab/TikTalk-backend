module Api
  module V1
    class ProfilesController < ApplicationController
      def update
        result = UserProfileUpdate.call(current_user, user_params, profile_params, update_attachment_params)
        if result.success?
          @current_user = result.updated_user
        else
          render json: { errors: result.message }, status: 422
        end
      end

      private

      def user_params
        params.permit(:name, :birth_date, :gender)
      end

      def profile_params
        params.permit(:work, :education, :about_you, :relationship,
                      :sexuality, :height, :living, :children,
                      :smoking, :drinking, speak:[])
      end

      def update_attachment_params
        params.permit(add_images:[], delete_images:[])
      end
    end
  end
end

