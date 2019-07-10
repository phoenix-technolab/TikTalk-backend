module Api
  module V1
    class BlockUsersController < ApplicationController      
      def create
        @block = current_user.block_users.new(receiver_id: block_params[:receiver_id],
                                              is_block: true)
        render_error(@block.errors) unless @block.save
      end

      def update
        @block = current_user.block_users.find_by(block_params)
        render_error unless @block.update(is_block: params[:is_block])
      end
      private

      def block_params
        params.permit(:receiver_id)
      end
    end
  end
end
