# frozen_string_literal: true

module Api
  module V1
    class ShirtsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_shirt, except: %i[index create]

      # GET /shirts
      def index
        @shirts = Shirt.all
        render json: @shirts, status: :ok
      end

      # POST /shirts
      def create
        @shirt = Shirt.create!(shirt_params)
        render json: @shirt, status: :created
      end

      # GET /shirts/:id
      def show
        render json: @shirt, status: :ok
      end

      # PUT /shirts/:id
      def update
        @shirt.update!(shirt_params)
        render json: @shirt, status: :ok
      end

      def destroy
        @shirt.destroy!
        render json: {}, status: :ok
      end

      private

      def shirt_params
        shirt_params = params.require(:shirt).permit(:color, :print, :size, :quantity, :aditional_description,
                                                     :store_id)
        @shirt.nil? ? shirt_params.merge(owner_id: current_user.id) : shirt_params
      end

      def find_shirt
        @shirt = Shirt.includes(:store, :owner).find(params[:id])
      end
    end
  end
end
