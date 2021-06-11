require_relative '../services/vehicle_model'

class VehicleModelsController < ApplicationController
  before_action :set_vehicle_model, only: [:show, :update, :destroy]

  # GET /vehicle_models
  def index
    @vehicle_models = VehicleModel.all

    render json: @vehicle_models
  end

  # GET /vehicle_models/1
  def show
    render json: @vehicle_model
  end

  # POST /vehicle_models
  def create
    @vehicle_model = VehicleModelService.create_vehicle_model(vehicle_model_params)

    if @vehicle_model.errors.present?
      render json: @vehicle_model.errors, status: :unprocessable_entity
    else
      render json: @vehicle_model, status: :created, location: @vehicle_model
    end
  end

  # PATCH/PUT /vehicle_models/1
  def update
    if @vehicle_model.update(vehicle_model_params)
      render json: @vehicle_model
    else
      render json: @vehicle_model.errors, status: :unprocessable_entity
    end
  end

  # DELETE /vehicle_models/1
  def destroy
    @vehicle_model.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_model
      @vehicle_model = VehicleModel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_model_params
      params.permit(:name, :brand)
    end
end
