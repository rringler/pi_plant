class Pump
  require Rails.env.test? ? "#{::Rails.root}/spec/support/pi_piper_mock" : "pi_piper"

  VALID_GPIO_PINS         = [4, 17, 18, 22, 23, 24, 25, 27]
  DEFAULT_IRRIGATION_TIME = 7 # seconds

  attr_reader :power_pin,
              :water_for

  def initialize(power_pin:, water_for: DEFAULT_IRRIGATION_TIME)
    raise invalid_power_pin_error unless VALID_GPIO_PINS.include?(power_pin)
    raise invalid_water_for_error unless (0..30).cover?(water_for)

    @power_pin = output_pin(power_pin)
    @water_for = water_for

    off
  end

  def irrigate
    on { sleep(water_for) }
  end

  private

  def invalid_power_pin_error
    ArgumentError.new(
      "Invalid power pin. The power pin must be one of the Raspberry Pi's "    \
      "GPIO pins: #{VALID_GPIO_PINS}"
    )
  end

  def invalid_water_for_error
    ArgumentError.new(
      "Invalid water_for duration.  The duration must be between 0 and 30 "    \
      "seconds."
    )
  end

  def on
    power_pin.on

    if block_given?
      yield power_pin
      power_pin.off
    end
  end

  def off
    power_pin.off
  end

  def output_pin(pin)
    PiPiper::Pin.new(pin: pin, direction: :out)
  end
end
