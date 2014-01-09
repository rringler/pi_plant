class Sensor
  if Rails.env.production?
    require 'pi_piper'
  else
    require "#{::Rails.root}/spec/support/pi_piper_mock"
  end

  VALID_GPIO_PINS    = [4, 17, 18, 22, 23, 24, 25, 27]
  VALID_ADC_CHANNELS = [0, 1, 2, 3, 4, 5, 6, 7]

  def initialize(options)
    raise "Invalid power pin. The power pin must be one of "\
          "the Raspberry Pi's GPIO pins: "\
          "#{VALID_GPIO_PINS}" unless VALID_GPIO_PINS.include?(options[:power_pin])
    raise "Invalid signal channel. The signal channel must be one of "\
          "the MCP3008's valid ADC channels: "\
          "#{VALID_ADC_CHANNELS}" unless VALID_ADC_CHANNELS.include?(options[:adc_channel])
    raise "Invalid minimum sensor value.  Value must be between "\
          "0 and 1023." unless (0..1023).cover?(options[:min_sensor_reading].to_i)
    raise "Invalid maximum sensor value.  Value must be between "\
          "0 and 1023." unless (0..1023).cover?(options[:max_sensor_reading].to_i)

    @power_pin   = PiPiper::Pin.new(pin: options[:power_pin], direction: :out)
    @adc_channel = options[:adc_channel]

    @min_sensor_reading = options[:min_sensor_reading] ||    0 # 10-bit theoretical limit
    @max_sensor_reading = options[:max_sensor_reading] || 1023 # 10-bit theoretical limit

    off
  end

  def measure
    on
    sleep 0.4 # Delay for the sensor to initialize

    # The MCP3008 isn't perfect, so we'll take 30 samples
    raw_samples = Array(1..30).map{sleep 0.1; read}

    off
    raw_samples.reduce(:+)/raw_samples.size # Find the average of the 30 samples
  end

  private

  def on
    @power_pin.on
  end

  def off
    @power_pin.off
  end

  def read
    value = 0
    raw = [0, 0, 1127] # Set greater than 1024 just in case SPI comms fails

    PiPiper::Spi.begin do |spi|
      raw = spi.write [1, (8+@adc_channel)<<4, 0] # bit pattern defined in MCP3008 datasheet
      value = ((raw[1]&3) << 8) + raw[2]          # bit pattern defined in MCP3008 datasheet
    end

    percentile(value)
  end

  def percentile(value)
    dynamic_range  = @max_sensor_reading - @min_sensor_reading
    adjusted_input = value - @min_sensor_reading

    100 - ((adjusted_input / dynamic_range.to_f) * 100).round
  end
end
