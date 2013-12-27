class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.integer :plant_id, null: false
      t.decimal :temperature
      t.decimal :humidity
      t.integer :moisture

      t.timestamps
    end

    add_index :samples, :plant_id
  end

  def self.down
    drop_table :samples
  end
end
