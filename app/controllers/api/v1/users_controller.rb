module Api
  module V1
    class UsersController < ApplicationController
      include TwilioMethods
      skip_before_action :authentication!, only: [:status_with_email, :auth]
      
      def show
        @user = User.find(params[:id])
      end

      def status_with_email
        @user = User.new(email: user_params[:email])
        @user.valid?
        if @user.errors[:email].blank?
          render json: { code: 404, message: "User does not exist" }, status: 404
        else
          render json: { result: "OK" }
        end
      end

      def friends
        @users = User.where(
          "CONCAT(code_country,phone_number) IN (:numbers)", 
          numbers: friends_params[:friends].map{|f| f.values.reduce(:+)}
        )
      end

      def auth
        result = Users::CreateUserWithPhotos.call(user_params, images_params)
        if result.success?
          @user = result.user
          response.headers["Auth-token"] = @user.tokens.first
        else
          render json: { error: result.message[:errors] }, status: result.message[:status]
        end
      end

      def sign_out
        tokens = current_user.tokens - [request.headers["Auth-token"]]
        current_user.update(tokens: tokens, firebase_token: nil)
      end

      def delete_account
        current_user.destroy
      end

      def twilio_user
        begin
          @twilio_user = twilio_service.users.create(identity: current_user.email)
          current_user.profile.update(twilio_user_id: @twilio_user.sid)
        rescue Twilio::REST::RestError => e
          render_error(e.message)
        end
      end

      def twilio_token
        grant = Twilio::JWT::AccessToken::ChatGrant.new
        grant.service_sid = ENV.fetch("TWILIO_SERVICE_SID")
        token = Twilio::JWT::AccessToken.new(
          ENV.fetch("TWILIO_ACCOUNT_SID"),
          ENV.fetch("TWILIO_API_KEY"),
          ENV.fetch("TWILIO_API_SECRET"),
          [grant],
          identity: current_user.email
        )
        render json: { token: token.to_jwt }
      end

      private

      def user_params
        params.permit(:email, :gender, :phone_number, :name,
                      :code_country, :country, :city, :birth_date,
                      :lat, :lng)
      end

      def friends_params
        params.permit(
          friends: [
            :country_code,
            :phone_number
          ]
        )
      end

      def images_params
        params.permit(images:[])
      end
    end
  end
end
