# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample do
    association :plant
    moisture    (500 + Kernel.rand(50))

    factory :dry_sample do
      moisture (200 + Kernel.rand(100))
    end

    factory :wet_sample do
      moisture (600 + Kernel.rand(75))
    end
  end
end
