class Pump
  def initialize(options)
    raise "Invalid power pin.  The power pin must be one of the 26 GPIO pins "\
          "on the Raspberry Pi" unless (1..26).cover?(options[:power_pin])

    @power_pin = PiPiper::Pin.new(pin: options[:power_pin], direction: :out)

    off
  end

  def water_for(duration=5)
    on
    sleep duration
    off
  end

  private

  def on
    @power_pin.on
  end

  def off
    @power_pin.off
  end
end
