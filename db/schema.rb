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

ActiveRecord::Schema.define(version: 20150510023937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "guesses", force: :cascade do |t|
    t.geometry "location",   limit: {:srid=>4326, :type=>"point"}, null: false
    t.integer  "spot_id",                                          null: false
    t.boolean  "correct",                                          null: false
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guesses", ["location"], name: "index_guesses_on_location", using: :btree
  add_index "guesses", ["spot_id"], name: "index_guesses_on_spot_id", using: :btree

  create_table "spots", force: :cascade do |t|
    t.geometry "location",           limit: {:srid=>4326, :type=>"point"}, null: false
    t.string   "image_file_name",                                          null: false
    t.string   "image_content_type",                                       null: false
    t.integer  "image_file_size",                                          null: false
    t.datetime "image_updated_at",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spots", ["location"], name: "index_spots_on_location", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token",                null: false
    t.string   "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["device_id", "email"], name: "index_users_on_device_id_and_email", unique: true, using: :btree
  add_index "users", ["device_id"], name: "index_users_on_device_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "guesses", "spots"
end
