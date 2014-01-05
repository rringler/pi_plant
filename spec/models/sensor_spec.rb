require 'spec_helper'

describe Sensor do
  describe 'instance methods' do
    describe '#initialize' do
      it 'should only accept a valid GPIO pins & ADC channels' do
        expect { Sensor.new(power_pin: 18, adc_channel: 0) }.to_not raise_error
        expect { Sessor.new(power_pin: 28, adc_channel: 0) }.to raise_error
        expect { Sessor.new(power_pin: 18, adc_channel: 8) }.to raise_error
      end

      it 'should turn the sensor off after initializing' do
        Sensor.any_instance.should_receive(:off)
        Sensor.new(power_pin: 18, adc_channel: 0)
      end
    end

    describe '#measure' do
      let(:sensor) { Sensor.new(power_pin: 18, adc_channel: 0) }

      it 'should turn the sensor on, '\
         'sleep for 0.4sec to let the ADC warm up, '\
         'take a measurement, '\
         'turn the sensor off, '\
         'and normalize the data' do
        sensor.should_receive(:on)
        sensor.should_receive(:sleep).with(0.4)

        30.times do
          sensor.should_receive(:sleep).with(0.1)
          sensor.should_receive(:read).and_return(Kernel.rand(1024))
        end

        sensor.should_receive(:off)

        sensor.measure
      end
    end
  end
end
