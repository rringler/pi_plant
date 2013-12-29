class Sensor
  MIN_SENSOR_READING = 0    # 10-bit limit.  Need to measure these.
  MAX_SENSOR_READING = 1024 # 10-bit limit.  Need to measure these.

  def initialize(options)
    raise "Invalid power pin.  The power pin must be one of the 26 GPIO pins "\
          "on the Raspberry Pi" unless (1..26).cover?(options[:power_pin])
    raise "Invalid signal channel.  The signal channel must be "\
          "between 0 and 7." unless (0..7).cover?(options[:adc_channel])

    @power_pin = PiPiper::Pin.new(pin: options[:power_pin], direction: :out)
    @adc_channel   = options[:adc_channel]

    off
  end

  def read
    on
    sleep 0.4 # Let the ADC turn on and measure the analog signal

    value = 0
    PiPiper::Spi.begin do |spi|
      raw = spi.write [1, (8+@adc_channel)<<4, 0]
      value = ((raw[1]&3) << 8) + raw[2]
    end

    off

    normalize(value)
  end

  private

  def on
    @power_pin.on
  end

  def off
    @power_pin.off
  end

  def normalize(value)
    ((value - MIN_SENSOR_READING) / MAX_SENSOR_READING).round
  end
end
