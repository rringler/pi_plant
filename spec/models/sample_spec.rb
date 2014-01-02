require 'spec_helper'

describe Sample do
  it 'should have valid factories' do
    FactoryGirl.create(:sample).should be_valid
    FactoryGirl.create(:dry_sample).should be_valid
    FactoryGirl.create(:wet_sample).should be_valid
  end

  describe 'validations' do
    describe 'plant_id' do
      it 'should be present' do
        FactoryGirl.build(:sample, plant_id: nil).should_not be_valid
      end
    end
  end
end
