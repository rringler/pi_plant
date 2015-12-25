# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plant do
    name "Random House Plant"
    signal_power_pin   18
    signal_channel      0
    pump_power_pin     23
    moisture_threshold 55
  end

  factory :plant2, class: :plant do
    name "Random House Plant2"
    signal_power_pin   24
    signal_channel      1
    pump_power_pin     25
    moisture_threshold 65
  end

  factory :plant3, class: :plant do
    name "Random House Plant3"
    signal_power_pin    4
    signal_channel      2
    pump_power_pin     11
    moisture_threshold 45
  end
end
