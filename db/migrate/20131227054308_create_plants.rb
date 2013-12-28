class CreatePlants < ActiveRecord::Migration
  def self.up
    create_table :plants do |t|
      t.string  :name,             null: false
      t.integer :signal_power_pin
      t.integer :signal_channel
      t.integer :pump_power_pin

      t.timestamps
    end
  end

  def self.down
    drop_table :plants
  end
end
