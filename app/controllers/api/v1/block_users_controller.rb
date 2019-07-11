module Api
  module V1
    class BlockUsersController < ApplicationController      
      def create
        @block = current_user.block_users.new(receiver_id: block_params[:receiver_id])
        render_error(@block.errors) unless @block.save
      end
      
      def destroy
        current_user.block_users.find_by(receiver_id: block_params[:receiver_id])&.destroy
      end

      private

      def block_params
        params.permit(:receiver_id)
      end
    end
  end
end
