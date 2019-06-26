module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authentication!, only: [:create, :auth]
      
      def create
        @user = User.new(user_params)
        if @user.valid?
          render json: { success: "User valid" }
        else
          render json: { errors: @user.errors }
        end
      end

      def auth
        result = CreateUserWithPhotos.call(user_params, images_params)
        if result.success?
          @user = result.user
          response.headers["Auth-token"] = @user.tokens.first
        else
          render json: result.message
        end
      end

      def sign_out
        token = current_user.tokens - [request.headers["Auth-token"]]
        current_user.update(tokens: token)
      end

      private

      def user_params
        params.permit(:email, :gender, :phone_number, :name,
                      :code_country, :country, :city, :birth_date)
      end

      def images_params
        params.permit(images:[])
      end
    end
  end
end
