require 'spec_helper'

describe Pump do
  describe 'instance methods' do
    describe '#initialize' do
      it 'should only accept a valid GPIO pin' do
        expect { Pump.new(power_pin: 1) }.to_not raise_error
        expect { Pump.new(power_pin: 44) }.to raise_error
      end

      it 'should turn the pump off after initializing' do
        Pump.any_instance.should_receive(:off)
        Pump.new(power_pin: 1)
      end
    end

    describe '#water_for' do
      let(:pump) { Pump.new(power_pin: 1) }

      it 'should turn the pump on to begin watering, '\
         'sleep for the specificed duration, '\
         'and turn the pump off to complete watering' do
        pump.should_receive(:on)
        pump.should_receive(:sleep).with(1)
        pump.should_receive(:off)

        pump.water_for(1)
      end
    end
  end
end
