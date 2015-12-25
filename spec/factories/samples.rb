# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample do
    plant
    moisture (500 + Kernel.rand(50))
  end

  factory :dry_sample, class: :sample do
    plant
    moisture (200 + Kernel.rand(100))
  end

  factory :wet_sample, class: :sample do
    plant
    moisture (600 + Kernel.rand(75))
  end
end
