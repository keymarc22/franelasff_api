class StoresController < ApplicationController
  before_action :find_store, except: [:index, :create]

  # GET /stores
  def index
    @stores = Store.all
    render json: { stores: @stores }, status: :ok
  end

  # POST /stores
  def create
    @store = Store.create!(store_params)
    render json: { store: @store }, status: :created
  end

  # GET /stores/:id
  def show
    render json: { store: @store }, status: :ok
  end

  # PUT /stores/:id
  def update
    @store.update!(store_params)
    render json: { store: @store }, status: :ok
  end

  def destroy
    @store.destroy!
    render json: {}, status: :ok
  end

  private

  def store_params
    params.require(:store).permit(:name, :location)
  end

  def find_store
    @store = Store.find(params[:id])
  end
end
