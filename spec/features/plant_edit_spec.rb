require 'spec_helper'

describe 'plants#edit' do
  let!(:plant) { FactoryGirl.create(:plant) }

  before(:each) do
    visit root_path
    click_link "#{plant.name}"
    click_link "Edit"
  end

  it 'should have a title' do
    page.should have_css("h2", text: "Edit plant")
  end

  it 'should have a text input prefilled with the plant\'s name' do
    page.should have_css("input#plant_name", exact: plant.name)
  end

  it 'should have a select input for the signal power pin' do
    page.should have_css("select#plant_signal_power_pin", exact: plant.signal_power_pin)
  end

  it 'should have a select input for the signal adc channel' do
    page.should have_css("select#plant_signal_channel", exact: plant.signal_channel)
  end

  it 'should have a select input for the pump power pin' do
    page.should have_css("select#plant_pump_power_pin", exact: plant.pump_power_pin)
  end

  it 'should have a slider input for the plant\'s moisture threshold' do
    page.should have_css("input#plant_moisture_threshold", exact: plant.moisture_threshold)
  end

  it 'should have a submit button' do
    page.should have_css("button", exact: "Save")
  end
end
