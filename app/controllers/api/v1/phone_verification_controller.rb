module Api
  module V1
    class PhoneVerificationController < ApplicationController
      skip_before_action :authentication!
      
      def send_code
        result = Registration::SendVerifyCodeAndSaveInRedis.call(check_params[:phone_number])
        if result.success?
          render json: { success: "Code successfully sended" }
        else
          render json: { error: result.message }
        end
      end

      def verify_code
        result = Registration::FindExistUserByPhoneNumber.call(verify_params[:code])
        if result.success?
          @user = result.user
          response.headers['Auth-token'] = result.user.tokens.last
          render status: 201
        else
          render json: { message: result.message[:message] }, status: result.message[:status]
        end
      end

      private

      def check_params
        params.permit(:phone_number)
      end

      def verify_params
        params.permit(:code)
      end
    end
  end
end
