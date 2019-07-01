module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authentication!, only: [:status_with_email, :auth]
      
      def status_with_email
        @user = User.new(email: user_params[:email])
        @user.valid?
        if @user.errors[:email].blank?
          render json: { code: 404, message: "User does not exist" }, status: 404
        else
          render json: { result: "OK" }
        end
      end

      def auth
        result = CreateUserWithPhotos.call(user_params, images_params)
        if result.success?
          @user = result.user
          response.headers["Auth-token"] = @user.tokens.first
        else
          render json: { error: result.message[:errors] }, status: result.message[:status]
        end
      end

      def sign_out
        tokens = current_user.tokens - [request.headers["Auth-token"]]
        current_user.update(tokens: token, firebase_token: nil)
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
