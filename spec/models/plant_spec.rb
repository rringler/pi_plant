require 'rails_helper'

describe Plant do
  context 'factories' do
    it 'should have a valid default factory' do
      expect(FactoryGirl.create(:plant)).to be_valid
    end

    it 'should have an alternate factory' do
      expect(FactoryGirl.create(:plant2)).to be_valid
    end

    it 'should have a third alternate factory' do
      expect(FactoryGirl.create(:plant3)).to be_valid
    end
  end

  describe 'validations' do
    it 'should have a name' do
      expect(FactoryGirl.build(:plant, name: nil)).to_not be_valid
    end

    it 'should have a unique signal_power_pin' do
      FactoryGirl.create(:plant, signal_power_pin: 4)
      expect(FactoryGirl.build(:plant2, signal_power_pin: 4)).to_not be_valid
    end

    it 'should have a unique signal_channel' do
      FactoryGirl.create(:plant, signal_channel: 0)
      expect(FactoryGirl.build(:plant2, signal_channel: 0)).to_not be_valid
    end

    it 'should have a unique pump_power_pin' do
      FactoryGirl.create(:plant, pump_power_pin: 4)
      expect(FactoryGirl.build(:plant2, pump_power_pin: 4)).to_not be_valid
    end
  end

  describe 'instance methods' do
    let(:plant) { FactoryGirl.create(:plant, moisture_threshold: 50) }

    context '#check_moisture_and_water_if_necessary' do
      it 'should turn on the pump if the moisture is below the threshold' do
        expect_any_instance_of(Sensor).to receive(:measure).and_return(45)
        expect_any_instance_of(Pump).to receive(:irrigate)

        plant.check_moisture_and_water_if_necessary
      end

      it 'should not turn on the pump if the moisture is above the threshold' do
        expect_any_instance_of(Sensor).to receive(:measure).and_return(55)
        expect_any_instance_of(Pump).to_not receive(:irrigate)

        plant.check_moisture_and_water_if_necessary
      end

      it 'should save the moisture sample' do
        expect_any_instance_of(Sensor).to receive(:measure).and_return(45)
        expect_any_instance_of(Pump).to receive(:irrigate)

        expect { plant.check_moisture_and_water_if_necessary }.to change(Sample, :count).by(1)
      end
    end
  end
end
