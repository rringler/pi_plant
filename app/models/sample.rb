class Sample < ActiveRecord::Base
  belongs_to :plant

  scope :recent,      -> (limit = 30) { order(created_at: :desc).limit(limit) }
  scope :most_recent, -> do
    if Sample.all.any?
      order(created_at: :desc).limit(1)
    else
      Sample.none.concat([null_sample])
    end
  end

  validates :plant_id, presence: true

  private

  def self.null_sample
    NullSample.new
  end

  class NullSample
    attr_reader :id,
                :plant_id,
                :moisture,
                :created_at,
                :edited_at

    def initialize
      @moisture = 0
    end
  end
end
