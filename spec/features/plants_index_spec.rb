require 'rails_helper'

describe 'plants#index' do
  context 'with previously created plants' do
    let(:plant1) { FactoryGirl.create(:plant) }
    let(:plant2) { FactoryGirl.create(:plant2) }

    before(:each) do
      (0..30).each do |t|
        FactoryGirl.create(:sample, plant_id: plant1.id,
                                    created_at: Time.now - t.day)
      end

      FactoryGirl.create(:sample, plant_id: plant2.id,
                                  created_at: Time.now)

      visit root_path
    end

    it 'should show any created plants' do
      expect(page).to have_css("h2", text: plant1.name)
      expect(page).to have_css("h2", text: plant2.name)
    end

    it 'should show the last moisture sample' do
      expect(page).to have_css("div#plant_#{plant1.id}_gauge_chart")
      expect(page).to have_css("div#plant_#{plant2.id}_gauge_chart")
    end

    it 'should show the last 30 days of soil samples' do
      expect(page).to have_css("div#plant_#{plant1.id}_histogram_chart")
      expect(page).to have_css("div#plant_#{plant2.id}_histogram_chart")
    end
  end

  context 'with no previously created plants' do
    before(:each) { visit root_path }

    it 'should have a "create new plant" link' do
      expect(page).to have_link('Create new plant')
    end

    it 'should render the new plant form when clicked' do
      click_link 'Create new plant'
      expect(current_path).to eq(new_plant_path)
    end
  end
end
