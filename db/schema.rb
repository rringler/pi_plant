# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131227054550) do

  create_table "plants", force: true do |t|
    t.string   "name",               null: false
    t.integer  "signal_power_pin"
    t.integer  "signal_channel"
    t.integer  "pump_power_pin"
    t.integer  "moisture_threshold"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "samples", force: true do |t|
    t.integer  "plant_id",   null: false
    t.integer  "moisture"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "samples", ["plant_id"], name: "index_samples_on_plant_id"

end
