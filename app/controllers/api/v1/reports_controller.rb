module Api
  module V1
    class ReportsController < ApplicationController
      def create
        @report = current_user.reports.new(report_params)
        unless @report.save
          render json: { error: @report.errors }
        end
      end

      private

      def report_params
        params.permit(:receiver_id, :report_type)
      end
    end
  end
end
