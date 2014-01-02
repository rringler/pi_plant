require 'spec_helper'

describe Sensor do
  describe 'instance methods' do
    describe '#initialize' do
      it 'should only accept a valid GPIO pins & ADC channels' do
        expect { Sensor.new(power_pin:  1, adc_channel: 1) }.to_not raise_error
        expect { Sessor.new(power_pin: 44, adc_channel: 1) }.to raise_error
        expect { Sessor.new(power_pin:  1, adc_channel: 9) }.to raise_error
      end

      it 'should turn the sensor off after initializing' do
        Sensor.any_instance.should_receive(:off)
        Sensor.new(power_pin: 1, adc_channel: 1)
      end
    end

    describe '#read' do
      let(:sensor) { Sensor.new(power_pin: 1, adc_channel: 1) }

      it 'should turn the sensor on, '\
         'sleep for 0.4sec to let the ADC warm up, '\
         'take a measurement, '\
         'turn the sensor off, '\
         'and normalize the data' do
        sensor.should_receive(:on)
        sensor.should_receive(:sleep).with(0.4)
        sensor.should_receive(:off)
        sensor.should_receive(:normalize)

        sensor.read
      end
    end
  end
end
