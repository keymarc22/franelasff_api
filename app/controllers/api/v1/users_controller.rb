# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user!
      before_action :find_user, except: %i[index create]

      # GET /users
      def index
        @users = User.without_current(current_user.id)
        render json: @users.map(), status: :ok
      end

      # POST /users
      def create
        @user = User.create!(user_params)
        render json: @user, status: :created, location: api_v1_user_path(@user)
      end

      # GET /users/:id
      def show
        render json: @user, status: :ok
      end

      private

      def user_params
        user_params = params.require(:user).permit(:name, :lastname, :country, :phone_number, :email, :password)
      end

      def find_user
        @user = User.find(params[:id])
      end
    end
  end
end
