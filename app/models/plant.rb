class Plant < ActiveRecord::Base
  has_many :samples

  validates_presence_of   :name
  validates_uniqueness_of :signal_channel,
                          :signal_power_pin,
                          :pump_power_pin

  DEFAULT_MAX_SENSOR = 830 # Measured with a sunkee soil hygrometer
  DEFAULT_MIN_SENSOR = 180 # Measured with a sunkee soil hygrometer

  def check_moisture_and_water_if_necessary
    irrigate if needs_watering?
    record_sample
  end

  private

  def irrigate
    pump.irrigate
  end

  def moisture_level
    @moisture_level ||= sensor.measure
  end

  def needs_watering?
    moisture_level < moisture_threshold
  end

  def pump
    @pump ||= Pump.new(power_pin: pump_power_pin)
  end

  def record_sample
    samples.create!(moisture: moisture)
  end

  def sensor(sensor_max: DEFAULT_MAX_SENSOR, sensor_min: DEFAULT_MIN_SENSOR)
    @sensor ||= Sensor.new(
      power_pin: signal_power_pin,
      adc_channel: signal_channel,
      sensor_max: sensor_max,
      sensor_min: sensor_min
    )
  end
end
