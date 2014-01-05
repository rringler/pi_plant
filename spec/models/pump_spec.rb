require 'spec_helper'

describe Pump do
  describe 'instance methods' do
    describe '#initialize' do
      it 'should only accept a valid GPIO pin' do
        expect { Pump.new(power_pin: 4) }.to_not raise_error
        expect { Pump.new(power_pin: 28) }.to raise_error
      end

      it 'should turn the pump off after initializing' do
        Pump.any_instance.should_receive(:off)
        Pump.new(power_pin: 4)
      end
    end

    describe '#irrigate' do
      let(:pump) { Pump.new(power_pin: 4) }

      it 'should turn the pump on to begin irrigation, '\
         'sleep for the specified (or default) duration, '\
         'and turn the pump off to complete irrigation' do
        pump.should_receive(:on)
        pump.should_receive(:sleep).with(7)
        pump.should_receive(:off)

        pump.irrigate
      end
    end
  end
end
