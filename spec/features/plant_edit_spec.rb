require 'spec_helper'

describe 'plants#edit' do
  let!(:plant) { FactoryGirl.create(:plant) }

  before(:each) do
    visit root_path
    click_link "#{plant.name}"
    click_link "Edit"

    save_and_open_page
  end

  it 'should have a title' do
    page.should have_css("h2", text: "Edit plant")
  end

  it 'should render the plants form' do
    page.should have_css('input[type="text"]', text: "#{plant.name}")
  end
end
