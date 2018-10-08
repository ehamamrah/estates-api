module Api
  module V1
    class EstatesController < ApplicationController
      before_action :find_real_estate, except: %i[index create search]
      before_action :retrieve_estates_by_creation_date, only: %i[index search]

      def index
        estates = paginate(@estates)
        success_response(estates)
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

      def search
        estates = paginate(@estates.filter(filtering_params))
        success_response(estates)
      end

      private

      def retrieve_estates_by_creation_date
        @estates = Estate.ordered_by_creation_date
      end

      def paginate(estates)
        estates.paginate(page: params[:page], per_page: 10)
      end

      def find_real_estate
        @estate = Estate.where(id: params[:id])
        return failure_response unless @estate.present?

        @estate
      end

      def estate_params
        params.require(:estate).permit(real_estate_fields)
      end

      def filtering_params
        params.slice(:type, :starting_square, :ending_square, :starting_price, :ending_price)
      end

      def real_estate_fields
        %i[street city zip state beds baths sq_ft residential_type sale_date price latitude longitude]
      end

      def success_response(estate)
        render json: { status: 'Success', message: 'Success Process', data: estate }
      end

      def failure_response
        render json: { status: 'Failed', message: 'Something Went Wrong' }
      end
    end
  end
end
