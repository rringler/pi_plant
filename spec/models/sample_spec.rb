require 'rails_helper'

describe Sample do
  context 'factories' do
    it 'should have a valid default factory' do
      expect(FactoryGirl.create(:sample)).to be_valid
    end
    it 'should have a valid dry_sample factory' do
      expect(FactoryGirl.create(:dry_sample)).to be_valid
    end
    it 'should have a valid wet_sample factory' do
      expect(FactoryGirl.create(:wet_sample)).to be_valid
    end
  end

  describe 'validations' do
    describe 'plant_id' do
      it 'should be present' do
        expect(FactoryGirl.build(:sample, plant_id: nil)).to_not be_valid
      end
    end
  end
end
