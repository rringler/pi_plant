require 'spec_helper'

describe Plant do
  it 'should have valid factories' do
    FactoryGirl.create(:plant).should be_valid
  end

  describe 'validations' do
    describe 'name' do
      it 'should be present' do
        FactoryGirl.build(:plant, name: nil).should_not be_valid
      end
    end
  end
end
