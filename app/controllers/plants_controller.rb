class PlantsController < ApplicationController
  def new
    @plant = Plant.new

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @plant = Plant.new(plant_params)

    if @plant.save
      redirect_to root_path, flash: { success: "New plant created!" }
    else
      render 'new'
    end
  end

  def index
    @plants = plants
  end

  def show
    @plant = plant
  end

  def edit
    @plant = plant
  end

  def update
    @plant = plant

    if @plant.update_attributes(plant_params)
      redirect_to @plant, flash: { success: "Plant updated." }
    else
      render 'edit'
    end
  end

  def destroy
    @plant = plant
    @plant.destroy

    redirect_to root_path
  end

  private

  def plant
    @plant ||= Plant.find(params[:id])
  end

  def plants
    @plants ||= Plant.all.decorate
  end

  def plant_params
    params.require(:plant)
          .permit(:name,
                  :signal_power_pin,
                  :signal_channel,
                  :pump_power_pin,
                  :moisture_threshold)
  end
end
