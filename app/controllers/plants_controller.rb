class PlantsController < ApplicationController
  def new
    @plant = Plant.new
  end

  def create
    @plant = Plant.new(plant_params)

    if @plant.save
      redirect_to @plant, flash: { success: "New plant created!" }
    else
      render 'new'
    end
  end

  def index
    @plants = Plant.all
  end

  def show
    @plant = Plant.where(id: params[:id]).first
  end

  def edit
    @plant = Plant.where(id: params[:id]).first
  end

  def update
    @plant = Plant.where(id: params[:id]).first

    if @plant.update_attributes(plant_params)
      redirect_to @plant, flash: { success: "Plant updated." }
    else
      render 'edit'
    end
  end

  def destroy
    @plant = Plant.where(id: params[:id]).first
    @plant.destroy
  end

  private

  def plant_params
    params.require(:plant).permit(:name,
                                  :signal_power_pin,
                                  :signal_channel,
                                  :pump_power_pin)
  end
end
