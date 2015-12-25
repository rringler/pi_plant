require "rails_helper"

describe Pump do
  describe "instance methods" do
    describe "#initialize" do
      it "only accept a valid GPIO pin" do
        expect { Pump.new(power_pin:  4) }.to_not raise_error
        expect { Pump.new(power_pin: 28) }.to     raise_error(ArgumentError)
      end

      it "only accept a valid water_for duration" do
        expect { Pump.new(power_pin:  4, water_for:  7) }.to_not raise_error
        expect { Pump.new(power_pin: 28, water_for: 32) }.to     raise_error(ArgumentError)
      end

      it "turns the pump off after initializing" do
        expect_any_instance_of(Pump).to receive(:off)
        Pump.new(power_pin: 4)
      end
    end

    describe "#irrigate" do
      let(:pump) { Pump.new(power_pin: 4) }

      before { allow(pump).to receive(:sleep) }

      subject { pump.irrigate }

      it "turns the sensor on" do
        expect(pump).to receive(:on).and_call_original
        subject
      end

      it "sleeps for the appropriate duration" do
        expect(pump).to receive(:sleep).with(7)
        subject
      end
    end

    # Private Methods

    describe "#off" do
      let(:pump) { Pump.new(power_pin: 4) }

      subject { pump.send(:off) }

      it "calls #off on the pump's power pin" do
        expect(pump.power_pin).to receive(:off)
        subject
      end
    end

    describe "#on" do
      let(:pump) { Pump.new(power_pin: 4) }

      context "when called without a block" do
        subject { pump.send(:on) }

        it "calls #on on the pump's power pin" do
          expect(pump.power_pin).to receive(:on)
          subject
        end
      end

      context "when called with a block" do
        let(:block) { Proc.new { |pin| } }

        subject { pump.send(:on, &block) }

        it "yields to the block" do
          expect { |b| pump.send(:on, &b) }.to yield_control
        end

        it "calls #off on the pump's power pin" do
          expect(pump.power_pin).to receive(:off)
          subject
        end
      end
    end

    describe "#output_pin" do
      let(:pump) { Pump.new(power_pin: 4) }

      subject { pump.send(:output_pin, 4) }

      it "returns a PiPiper::Pin instance" do
        expect(subject).to be_an_instance_of(PiPiper::Pin)
      end
    end
  end
end
