# frozen_string_literal: true

class CataloguesController < ApplicationController
  before_action :find_catalogue, except: %i[index create]

  # GET /catalogues
  def index
    @catalogues = Catalogue.all
    render json: { catalogues: @catalogues }, status: :ok
  end

  # POST /catalogues
  def create
    @catalogue = Catalogue.create!(catalogue_params)
    render json: { catalogue: @catalogue }, status: :created
  end

  # GET /catalogues/:id
  def show
    render json: { catalogue: @catalogue }, status: :ok
  end

  # PUT /catalogues/:id
  def update
    @catalogue.update!(catalogue_params)
    render json: { catalogue: @catalogue }, status: :ok
  end

  def destroy
    @catalogue.destroy!
    render json: {}, status: :ok
  end

  private

  def catalogue_params
    params.require(:catalogue).permit(:title, :description, :owner_id)
  end

  def find_catalogue
    @catalogue = Catalogue.find(params[:id])
  end
end
