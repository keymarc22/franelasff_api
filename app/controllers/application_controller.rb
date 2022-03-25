# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Secured

  rescue_from Exception do |e|
    render json: { error: e.message }, status: :internal_server_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
