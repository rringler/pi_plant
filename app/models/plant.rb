class Plant < ActiveRecord::Base
  has_many :samples

  validates :name, presence: true
  validates :signal_channel, uniqueness: true
  validates :signal_power_pin, uniqueness: true
  validates :pump_power_pin, uniqueness: true


  def check_moisture_and_water_if_necessary
    moisture = sensor.measure

    pump.irrigate if moisture < moisture_threshold
    samples.create(moisture: moisture).save
  end

  private

  def pump
    @pump ||= Pump.new(power_pin: pump_power_pin)
  end

  def sensor
    @sensor ||= Sensor.new(power_pin:   signal_power_pin,
                           adc_channel: signal_channel)
  end
end
