class Plant < ActiveRecord::Base
  has_many :samples

  validates :name, presence: true
end
