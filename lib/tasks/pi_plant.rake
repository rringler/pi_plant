desc "Take a sample for each plant"
task :sample => :environment do
  Plant.all.each do |plant|
    pump = Pump.new(power_pin:       plant.pump_power_pin)
    sensor = Sensor.new(power_pin:   plant.signal_power_pin,
                        adc_channel: plant.signal_channel)

    moisture = sensor.read
    pump.water_for(5) if moisture < plant.moisture_threshold

    plant.sample.create(moisture: moisture).save  # Save the sample
  end
end
