# frozen_string_literal: true

module Api
  module V1
    class StoresController < ApplicationController
      before_action :authenticate_user!
      before_action :find_store, except: %i[index create]

      # GET /stores
      def index
        @stores = Store.includes(:shirts, :owner).all
        render json: @stores, status: :ok
      end

      # POST /stores
      def create
        @store = Store.create!(store_params)
        render json: @store, status: :created
      end

      # GET /stores/:id
      def show
        render json: @store, status: :ok
      end

      # PUT /stores/:id
      def update
        @store.update!(store_params)
        render json: @store, status: :ok
      end

      def destroy
        @store.destroy!
        render json: {}, status: :ok
      end

      private

      def store_params
        store_params = params.require(:store).permit(:name, :location)
        @store.nil? ? store_params.merge(owner_id: current_user.id) : store_params
      end

      def find_store
        @store = Store.includes(:shirts, :owner).find(params[:id])
      end
    end
  end
end
