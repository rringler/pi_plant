require "rails_helper"

describe Sensor do
  describe "instance methods" do
    describe "#initialize" do
      it "only accept a valid GPIO pins & ADC channels" do
        expect { Sensor.new(power_pin: 18, adc_channel: 0) }.to_not raise_error
        expect { Sensor.new(power_pin: 28, adc_channel: 0) }.to raise_error(ArgumentError)
        expect { Sensor.new(power_pin: 18, adc_channel: 8) }.to raise_error(ArgumentError)
      end

      it "turns the sensor off after initializing" do
        expect_any_instance_of(Sensor).to receive(:off)
        Sensor.new(power_pin: 18, adc_channel: 0)
      end
    end

    describe "#measure" do
      let(:sensor)  { Sensor.new(power_pin: 18, adc_channel: 0) }
      let(:samples) { [968, 955, 940] }

      before { allow(sensor).to receive(:sample).and_return(samples) }

      subject { sensor.measure }

      it "turns the sensor on" do
        expect(sensor).to receive(:on).and_call_original

        subject
      end

      it "takes multiple samples" do
        expect(sensor).to receive(:sample).with(
          a_hash_including(number: instance_of(Fixnum))
        )

        subject
      end

      it "returns the average of the normalized samples" do
        expect(subject).to be_a(Float)
      end
    end

    # Private Methods

    describe "#dynamic_range" do
      let(:sensor)         { Sensor.new(sensor_options) }
      let(:sensor_min)     { 100 }
      let(:sensor_max)     { 200 }
      let(:sensor_options) do
        {
          power_pin: 18,
          adc_channel: 0,
          sensor_min: sensor_min,
          sensor_max: sensor_max
        }
      end

      subject { sensor.send(:dynamic_range) }

      it "returns the the difference of the sensor's max and min" do
        expect(subject).to eq(sensor_max - sensor_min)
      end
    end

    describe "#mcp3002_input_bytes" do
      let(:sensor) { Sensor.new(power_pin: 18, adc_channel: adc_channel) }

      subject { sensor.send(:mcp3002_input_bytes) }

      context "when the adc_channel is set to 0" do
        let(:adc_channel) { 0 }

        it "returns the correct bytes" do
          expect(subject).to match_array(
            [
              0b01101000,
              0b00000000
            ]
          )
        end
      end

      context "when the adc_channel is set to 1" do
        let(:adc_channel) { 1 }

        it "returns the correct bytes" do
          expect(subject).to match_array(
            [
              0b01111000,
              0b00000000
            ]
          )
        end
      end
    end

    describe "#measurable" do
      let(:sensor)         { Sensor.new(sensor_options) }
      let(:sensor_min)     { 100 }
      let(:sensor_max)     { 200 }
      let(:sensor_options) do
        {
          power_pin: 18,
          adc_channel: 0,
          sensor_min: sensor_min,
          sensor_max: sensor_max
        }
      end

      subject { sensor.send(:measurable, value) }

      context "when the raw value is greater than max sensor value" do
        let(:value) { sensor_max + 5 }

        it "returns the sensor_max" do
          expect(subject).to eq(sensor_max)
        end
      end

      context "when the raw value is less than the min sensor value" do
        let(:value) { sensor_min - 5 }

        it "returns the sensor_max" do
          expect(subject).to eq(sensor_min)
        end
      end

      context "when the raw value is between the sensor_min & sensor_max" do
        let(:value) { sensor_max - 5 }

        it "returns the sensor_max" do
          expect(subject).to eq(value)
        end
      end
    end

    describe "#normalized" do
      let(:sensor)         { Sensor.new(sensor_options) }
      let(:sensor_min)     { 100 }
      let(:sensor_max)     { 200 }
      let(:sensor_options) do
        {
          power_pin: 18,
          adc_channel: 0,
          sensor_min: sensor_min,
          sensor_max: sensor_max
        }
      end

      it "returns the correct normalized values" do
        expect(sensor.send(:normalized,  50)).to eq(  0.0)
        expect(sensor.send(:normalized, 100)).to eq(  0.0)
        expect(sensor.send(:normalized, 150)).to eq( 50.0)
        expect(sensor.send(:normalized, 200)).to eq(100.0)
        expect(sensor.send(:normalized, 250)).to eq(100.0)
      end
    end

    describe "#off" do
      let(:sensor) { Sensor.new(power_pin: 18, adc_channel: 0) }

      subject { sensor.send(:off) }

      it "calls #off on the sensor's power pin" do
        expect(sensor.power_pin).to receive(:off)
        subject
      end
    end

    describe "#on" do
      let(:sensor) { Sensor.new(power_pin: 18, adc_channel: 0) }

      context "when called without a block" do
        subject { sensor.send(:on) }

        it "calls #on on the sensor's power pin" do
          expect(sensor.power_pin).to receive(:on)
          subject
        end
      end

      context "when called with a block" do
        let(:block) { Proc.new { |pin| } }

        subject { sensor.send(:on, &block) }

        it "yields to the block" do
          expect { |b| sensor.send(:on, &b) }.to yield_control
        end

        it "calls #off on the sensor's power pin" do
          expect(sensor.power_pin).to receive(:off)
          subject
        end
      end
    end

    describe "#output_pin" do
      let(:sensor) { Sensor.new(power_pin: 18, adc_channel: 0) }

      subject { sensor.send(:output_pin, 18) }

      it "returns a PiPiper::Pin instance" do
        expect(subject).to be_an_instance_of(PiPiper::Pin)
      end
    end

    describe "#read" do
      let(:sensor) { Sensor.new(power_pin: 18, adc_channel: 0) }
      let(:bytes)  { [0b00000011, 0b00000011] }

      before { allow(PiPiper::Spi).to receive(:begin).and_return(bytes) }

      subject { sensor.send(:read) }

      it "returns the correct results" do
        expect(subject).to eq(
          ((bytes[0] & 3) << 8) + bytes[1]
        )
      end
    end

    describe "#sample" do
      let(:sensor)       { Sensor.new(power_pin: 18, adc_channel: 0) }
      let(:number)       { 5 }
      let(:delay)        { 0.1 }
      let(:return_bytes) { [1, 1] }

      before do
        allow(sensor).to receive(:sleep)
        allow(sensor).to receive(:read).and_return(return_bytes)
      end

      subject { sensor.send(:sample, number: number, delay: delay) }

      it "sleeps for the delay duration" do
        expect(sensor).to receive(:sleep).with(delay).exactly(number).times
        subject
      end

      it "calls #read the specified number of times" do
        expect(sensor).to receive(:read).and_return(return_bytes).exactly(number).times
        subject
      end
    end
  end
end
