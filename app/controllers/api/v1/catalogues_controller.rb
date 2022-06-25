# frozen_string_literal: true

module Api
  module V1
    class CataloguesController < ApplicationController
      before_action :authenticate_user!, except: %i[show index]
      before_action :find_catalogue, except: %i[index create]

      # GET /catalogues
      def index
        @catalogues = Catalogue.includes(:shirts, :owner).all
        render json: @catalogues, status: :ok
      end

      # POST /catalogues
      def create
        @catalogue = Catalogue.create!(catalogue_params)
        render json: @catalogue, status: :created, location: api_v1_catalogue_path(@catalogue)
      end

      # GET /catalogues/:id
      def show
        render json: @catalogue, status: :ok
      end

      # PUT /catalogues/:id
      def update
        @catalogue.update!(catalogue_params)
        render json: @catalogue, status: :ok
      end

      def destroy
        @catalogue.destroy!
        render json: {}, status: :ok
      end

      private

      def catalogue_params
        catalogue_params = params.require(:catalogue).permit(:title, :description)
        @catalogue.nil? ? catalogue_params.merge(owner_id: current_user.id) : catalogue_params
      end

      def find_catalogue
        @catalogue = Catalogue.includes(:shirts, :owner).find(params[:id])
      end
    end
  end
end
