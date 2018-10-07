module Api
  module V1
    class EstatesController < ApplicationController
      before_action :find_real_estate, except: %i[index create]

      def index
        estates = Estate.order('created_at DESC')
        render json: { status: 'Success', message: 'Estates List', data: estates }
      end

      def show
        success_response(@estate)
      end

      def create
        estate = Estate.new(estate_params)
        estate.save ? success_response(estate) : failure_response
      end

      def update
        @estate.update_attributes(estate_params) ? success_response(@estate) : failure_response
      end

      def destroy
        @estate.destroy
        render json: { status: 'Success', message: 'Removed real estate from our list' }
      end

      private

      def find_real_estate
        @estate = Estate.where(id: params[:id])
        return failure_response unless @estate.present?
        @estate
      end

      def estate_params
        params.require(:estate).permit(real_estate_fields)
      end

      def real_estate_fields
        %i[street city zip state beds baths sq_ft residential_type sale_date price latitude longitude]
      end

      def success_response(estate)
        render json: { status: 'Success', message: 'Success Process', data: estate }
      end

      def failure_response
        render json: { status: 'Failed', message: 'Something Went Wrong'}
      end
    end
  end
end
