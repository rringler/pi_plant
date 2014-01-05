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
end
