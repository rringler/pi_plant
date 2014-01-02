class Sample < ActiveRecord::Base
  belongs_to :plant

  scope :recent, ->(limit = 30) { order('created_at DESC').limit(limit) }
  scope :most_recent, -> { order('created_at DESC').limit(1) }

  validates :plant_id, presence: true
end
