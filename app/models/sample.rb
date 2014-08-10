class Sample < ActiveRecord::Base
  require 'nullsample.rb'

  belongs_to :plant

  scope :recent, ->(limit = 30) { order('created_at DESC').limit(limit) }
  scope :most_recent, -> do
    if order('created_at DESC').any?
      order('created_at DESC').limit(1).first
    else
      NullSample.new
    end
  end

  validates :plant_id, presence: true
end
