class Sensor
  require Rails.env.test? ? "#{::Rails.root}/spec/support/pi_piper_mock" : "pi_piper"

  VALID_GPIO_PINS    = [4, 17, 18, 22, 23, 24, 25, 27]
  VALID_ADC_CHANNELS = [0, 1]
  VALID_SENSOR_RANGE = (0..1023)

  attr_reader :adc_channel,
              :samples,
              :sensor_max,
              :sensor_min,
              :power_pin

  def initialize(power_pin:, adc_channel:, sensor_min: 0, sensor_max: 1023)
    raise invalid_power_pin_error        unless VALID_GPIO_PINS.include?(power_pin)
    raise invalid_signal_pin_error       unless VALID_ADC_CHANNELS.include?(adc_channel)
    raise invalid_min_sensor_value_error unless VALID_SENSOR_RANGE.cover?(sensor_min)
    raise invalid_max_sensor_value_error unless VALID_SENSOR_RANGE.cover?(sensor_max)

    @power_pin   = output_pin(power_pin)
    @adc_channel = adc_channel
    @sensor_max  = sensor_max
    @sensor_min  = sensor_min

    off
  end

  def measure
    on do
      sleep(0.4) # Delay for the sensor to initialize

      @samples = sample(number: 30, delay: 0.1) # Grab multiple samples to average
    end

    samples.map { |s| normalized(s) } # Map to a normalized value: 0 - 100
           .reduce(:+)                 # Sum the normalized values
           ./(samples.size.to_f)       # Divide by the number of samples
  end

  private

  def dynamic_range
    sensor_max - sensor_min
  end

  def invalid_power_pin_error
    ArgumentError.new(
      "Invalid power pin. The power pin must be one of the Raspberry Pi's "    \
      "GPIO pins: #{VALID_GPIO_PINS}"
    )
  end

  def invalid_signal_pin_error
    ArgumentError.new(
      "Invalid signal channel. The signal channel must be one of the "         \
      "MCP3002's valid ADC channels: #{VALID_ADC_CHANNELS}"
    )
  end

  def invalid_max_sensor_value_error
    ArgumentError.new(
      "Invalid maximum sensor value.  Value must be between 0 and 1023."
    )
  end

  def invalid_min_sensor_value_error
    ArgumentError.new(
      "Invalid minimum sensor value.  Value must be between 0 and 1023."
    )
  end

  def mcp3002_input_bytes
    start     = 0b01000000
    sgl       = 0b00100000
    msbf      = 0b00001000
    adc       = adc_channel << 4 # 0: 0b00000000, 1: 0b00010000
    dont_care = 0b00000000

    [
      (start | sgl | msbf | adc),
      dont_care
    ]
  end

  def measurable(raw)
    value = [  raw, sensor_max].min
    value = [value, sensor_min].max
    value
  end

  def normalized(value)
    (((measurable(value) - sensor_min) / dynamic_range.to_f) * 100).round
  end

  def off
    power_pin.off
  end

  def on
    power_pin.on

    if block_given?
      yield power_pin
      power_pin.off
    end
  end

  def output_pin(pin)
    PiPiper::Pin.new(pin: pin, direction: :out)
  end

  def read
    # The MCP3002 returns ten bits of precision, split over two bytes
    byte1, byte2 = PiPiper::Spi.begin { |spi| spi.write(mcp3002_input_bytes) }

    ((byte1 & 3) << 8) + byte2 # Select the first two bits of byte1 by
                               # bitwise-and(3) and left-shift by eight bits.
                               # Then add the value of byte2
  end

  def sample(number: 1, delay: 0)
    (1..number).map { sleep(delay); read }
  end
end
