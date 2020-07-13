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
        # result = Registration::FindExistUserByPhoneNumber.call(verify_params[:code])
        # if result.success?
        #   @user = result.user
        #   puts "=====#{@user.as_json}"
        #   response.headers['Auth-token'] = result.user.tokens.last
        #   render json: {message: result.message[:message], user: @user}, status: 201
        # else
        #   render json: { message: result.message[:message], user: @user }, status: result.message[:status]
        # end
        phone_number = MyRedis.client.get(verify_params[:code])
        puts "====phone_number==#{phone_number}"
        @user = User.where("CONCAT(phone_number) = ?", phone_number).take
        if @user.present? && @user.is_account_block
          render json: { message: "Your account has been blocked. For more info Contact Support", status: 403 }
        elsif @user.present?
          @user.create_new_auth_token
          @user.save
          render status: 200
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
