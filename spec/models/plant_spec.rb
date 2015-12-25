require "rails_helper"

describe Plant do
  context "factories" do
    it "has a valid default factory" do
      expect(FactoryGirl.create(:plant)).to be_valid
    end

    it "has an alternate factory" do
      expect(FactoryGirl.create(:plant2)).to be_valid
    end

    it "has a third alternate factory" do
      expect(FactoryGirl.create(:plant3)).to be_valid
    end
  end

  describe "validations" do
    it "requires the plant have a name" do
      expect(FactoryGirl.build(:plant, name: nil)).to_not be_valid
    end

    it "requires the plant have a unique signal_power_pin" do
      FactoryGirl.create(:plant, signal_power_pin: 4)
      expect(FactoryGirl.build(:plant2, signal_power_pin: 4)).to_not be_valid
    end

    it "requires the plant have a unique signal_channel" do
      FactoryGirl.create(:plant, signal_channel: 0)
      expect(FactoryGirl.build(:plant2, signal_channel: 0)).to_not be_valid
    end

    it "requires the plant have a unique pump_power_pin" do
      FactoryGirl.create(:plant, pump_power_pin: 4)
      expect(FactoryGirl.build(:plant2, pump_power_pin: 4)).to_not be_valid
    end
  end

  describe "instance methods" do
    describe "#check_moisture_and_water_if_necessary" do
      let(:plant)   { Plant.new(options) }
      let(:options) do
        {
          signal_power_pin: 18,
          signal_channel: 0,
          pump_power_pin: 23,
          moisture_threshold: 50
        }
      end

      before { allow(plant).to receive(:needs_watering?).and_return(needs_watering) }

      subject { plant.check_moisture_and_water_if_necessary }

      context "when #needs_watering? returns true" do
        let(:needs_watering) { true }

        before do
          allow(plant).to receive(:irrigate)
          allow(plant).to receive(:record_sample)
        end

        it "calls #irrigate" do
          expect(plant).to receive(:irrigate)
          subject
        end

        it "calls #record_sample" do
          expect(plant).to receive(:record_sample)
          subject
        end
      end

      context "when #needs_watering? returns false" do
        let(:needs_watering) { false }

        before { allow(plant).to receive(:record_sample) }

        it "does not call #irrigate" do
          expect(plant).to_not receive(:irrigate)
          subject
        end

        it "calls #record_sample" do
          expect(plant).to receive(:record_sample)
          subject
        end
      end
    end

    # Private Method

    describe "#irrigate" do
      let(:plant) { Plant.new }
      let(:pump)  { instance_double("Pump") }

      before { allow(plant).to receive(:pump).and_return(pump) }

      subject { plant.send(:irrigate) }

      it "calls #irrigate on the plant's pump" do
        expect(pump).to receive(:irrigate)
        subject
      end
    end

    describe "#moisture_level" do
      let(:plant)  { Plant.new }
      let(:sensor) { instance_double("Sensor") }

      before { allow(plant).to receive(:sensor).and_return(sensor) }

      subject { plant.send(:moisture_level) }

      it "calls #measure on the plant's sensor" do
        expect(sensor).to receive(:measure)
        subject
      end
    end

    describe "#needs_watering?" do
      let(:plant) { Plant.new }

      before do
        allow(plant).to receive(:moisture_level).and_return(moisture_level)
        allow(plant).to receive(:moisture_threshold).and_return(moisture_threshold)
      end

      subject { plant.send(:needs_watering?) }

      context "when the moisture_level is below the moisture_threshold" do
        let(:moisture_level)     { 40 }
        let(:moisture_threshold) { 50 }

        it "returns true" do
          expect(subject).to be true
        end
      end

      context "when the moisture_level is above the moisture_threshold" do
        let(:moisture_level)     { 60 }
        let(:moisture_threshold) { 50 }

        it "returns false" do
          expect(subject).to be false
        end
      end
    end

    describe "#pump" do
      let(:plant) { Plant.new(pump_power_pin: 23) }

      subject { plant.send(:pump) }

      it "returns an instance of Pump" do
        expect(subject).to be_an_instance_of(Pump)
      end
    end

    describe "#record_sample" do
      let(:plant)          { Plant.new }
      let(:moisture_level) { 30 }

      before { allow(plant).to receive(:moisture).and_return(moisture_level) }

      subject { plant.send(:record_sample) }

      it "calls samples#create!" do
        expect(plant.samples).to receive(:create!).with(moisture: moisture_level)
        subject
      end
    end

    describe "#sensor" do
      let(:plant) { Plant.new(options) }
      let(:options) do
        {
          signal_power_pin: 18,
          signal_channel: 0
        }
      end

      subject { plant.send(:sensor) }

      it "returns an instance of Sensor" do
        expect(subject).to be_an_instance_of(Sensor)
      end
    end
  end
end
