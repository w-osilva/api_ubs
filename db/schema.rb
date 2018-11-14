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

ActiveRecord::Schema.define(version: 2018_11_13_193927) do

  create_table "geocodes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.decimal "lat", precision: 15, scale: 13
    t.decimal "long", precision: 15, scale: 13
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lat", "long"], name: "index_geocodes_on_lat_and_long"
  end

  create_table "scores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "size", limit: 2
    t.integer "adaptation_for_seniors", limit: 2
    t.integer "medical_equipment", limit: 2
    t.integer "medicine", limit: 2
    t.bigint "ubs_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ubs_id"], name: "index_scores_on_ubs_id"
  end

  create_table "ubs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "address"
    t.string "city"
    t.string "phone"
    t.bigint "geocode_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geocode_id"], name: "index_ubs_on_geocode_id"
    t.index ["name", "address", "city"], name: "index_ubs_on_name_and_address_and_city"
  end

  add_foreign_key "scores", "ubs"
  add_foreign_key "ubs", "geocodes"
end
