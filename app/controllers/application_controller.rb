# frozen_string_literal: true

class ApplicationController < ActionController::API
  # respond_to :json
  # protect_from_forgery with: :null_session
  # before_action :authenticate_user
  rescue_from Exception do |e|
    render json: {error: e.message}, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: {error: e.message}, status: :unprocessable_entity
  end
end
