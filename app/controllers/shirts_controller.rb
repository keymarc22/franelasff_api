# frozen_string_literal: true

class ShirtsController < ApplicationController
  before_action :find_shirt, except: %i[index create]

  # GET /shirts
  def index
    @shirts = Shirt.all
    render json: { shirts: @shirts }, status: :ok
  end

  # POST /shirts
  def create
    @shirt = Shirt.create!(shirt_params)
    render json: { shirt: @shirt }, status: :created
  end

  # GET /shirts/:id
  def show
    render json: { shirt: @shirt }, status: :ok
  end

  # PUT /shirts/:id
  def update
    @shirt.update!(shirt_params)
    render json: { shirt: @shirt }, status: :ok
  end

  def destroy
    @shirt.destroy!
    render json: {}, status: :ok
  end

  private

  def shirt_params
    params.require(:shirt).permit(:color, :print, :size, :quantity, :aditional_description, :store_id, :owner_id)
  end

  def find_shirt
    @shirt = Shirt.find(params[:id])
  end
end
