module Api
  module V1
    class BlockUsersController < ApplicationController
      include RenderMethods
      
      def create
        @block = current_user.block_users.new(block_params)

        unless @block.save
          render_error(@block.errors)
        end
      end

      private

      def block_params
        params.permit(:receiver_id, :is_block)
      end
    end
  end
end
