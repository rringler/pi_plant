# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plant do
    name             "Random House Plant"
    signal_power_pin   16
    signal_channel      0
    pump_power_pin     24
    moisture_threshold 65
  end
end
