require 'spec_helper'

describe Plant do
  context 'factories' do
    it 'should have a valid default factory' do
      FactoryGirl.create(:plant).should be_valid
    end

    it 'should have an alternate factory' do
      FactoryGirl.create(:plant2).should be_valid
    end

    it 'should have a third alternate factory' do
      FactoryGirl.create(:plant3).should be_valid
    end
  end

  describe 'validations' do
    it 'should have a name' do
      FactoryGirl.build(:plant, name: nil).should_not be_valid
    end

    it 'should have a unique signal_power_pin' do
      FactoryGirl.create(:plant, signal_power_pin: 4)
      FactoryGirl.build(:plant2, signal_power_pin: 4).should_not be_valid
    end

    it 'should have a unique signal_channel' do
      FactoryGirl.create(:plant, signal_channel: 0)
      FactoryGirl.build(:plant2, signal_channel: 0).should_not be_valid
    end

    it 'should have a unique pump_power_pin' do
      FactoryGirl.create(:plant, pump_power_pin: 4)
      FactoryGirl.build(:plant2, pump_power_pin: 4).should_not be_valid
    end
  end

  describe 'instance methods' do
    let(:plant) { FactoryGirl.create(:plant, moisture_threshold: 50) }

    context '#check_moisture_and_water_if_necessary' do
      it 'should turn on the pump if the moisture is below the threshold' do
        Sensor.any_instance.should_receive(:measure).and_return(45)
        Pump.any_instance.should_receive(:irrigate)

        plant.check_moisture_and_water_if_necessary
      end

      it 'should not turn on the pump if the moisture is above the threshold' do
        Sensor.any_instance.should_receive(:measure).and_return(55)
        Pump.any_instance.should_not_receive(:irrigate)

        plant.check_moisture_and_water_if_necessary
      end

      it 'should save the moisture sample' do
        Sensor.any_instance.should_receive(:measure).and_return(45)
        Pump.any_instance.should_receive(:irrigate)

        expect { plant.check_moisture_and_water_if_necessary }.to change(Sample, :count).by(1)
      end
    end
  end
end
