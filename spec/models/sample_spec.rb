require 'spec_helper'

describe Sample do
  context 'factories' do
    it 'should have a valid default factory' do
      FactoryGirl.create(:sample).should be_valid
    end
    it 'should have a valid dry_sample factory' do
      FactoryGirl.create(:dry_sample).should be_valid
    end
    it 'should have a valid wet_sample factory' do
      FactoryGirl.create(:wet_sample).should be_valid
    end
  end

  describe 'validations' do
    describe 'plant_id' do
      it 'should be present' do
        FactoryGirl.build(:sample, plant_id: nil).should_not be_valid
      end
    end
  end
end
