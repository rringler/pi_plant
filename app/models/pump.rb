class Pump
  if Rails.env.production?
    require 'pi_piper'
  else
    require "#{::Rails.root}/spec/support/pi_piper_mock"
  end

  VALID_GPIO_PINS    = [4, 17, 18, 22, 23, 24, 25, 27]

  def initialize(options)
    raise "Invalid power pin. The power pin must be one of "\
          "the Raspberry Pi's GPIO pins: "\
          "#{VALID_GPIO_PINS}" unless VALID_GPIO_PINS.include?(options[:power_pin])
    raise "Invalid sleep duration.  The duration must be between "\
          "0 and 30 seconds." unless (0..30).cover?(options[:sleep_duration].to_i)

    @power_pin = PiPiper::Pin.new(pin: options[:power_pin], direction: :out)
    @sleep_duration = options[:sleep_duration] || 7

    off
  end

  def irrigate
    on
    sleep @sleep_duration
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
