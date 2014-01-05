class Plant < ActiveRecord::Base
  has_many :samples

  validates :name, presence: true
  validates :signal_channel, uniqueness: true
  validates :signal_power_pin, uniqueness: true
  validates :pump_power_pin, uniqueness: true
end
