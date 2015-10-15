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

ActiveRecord::Schema.define(version: 20150923164547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "api_keys", force: :cascade do |t|
    t.string   "client_id",  null: false
    t.integer  "user_id",    null: false
    t.string   "secret",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "api_keys", ["client_id"], name: "index_api_keys_on_client_id", unique: true, using: :btree
  add_index "api_keys", ["secret"], name: "index_api_keys_on_secret", unique: true, using: :btree
  add_index "api_keys", ["user_id"], name: "index_api_keys_on_user_id", using: :btree

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guesses", force: :cascade do |t|
    t.geometry "location",           limit: {:srid=>4326, :type=>"point"}, null: false
    t.integer  "spot_id",                                                  null: false
    t.boolean  "correct",                                                  null: false
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                                  null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "guesses", ["location"], name: "index_guesses_on_location", using: :btree
  add_index "guesses", ["spot_id"], name: "index_guesses_on_spot_id", using: :btree
  add_index "guesses", ["user_id"], name: "index_guesses_on_user_id", using: :btree

  create_table "score_transactions", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "amount",      null: false
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "score_transactions", ["user_id"], name: "index_score_transactions_on_user_id", using: :btree

  create_table "spots", force: :cascade do |t|
    t.geometry "location",           limit: {:srid=>4326, :type=>"point"}, null: false
    t.string   "image_file_name",                                          null: false
    t.string   "image_content_type",                                       null: false
    t.integer  "image_file_size",                                          null: false
    t.datetime "image_updated_at",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                                  null: false
    t.integer  "game_id",                                                  null: false
  end

  add_index "spots", ["game_id"], name: "index_spots_on_game_id", using: :btree
  add_index "spots", ["location"], name: "index_spots_on_location", using: :btree
  add_index "spots", ["user_id"], name: "index_spots_on_user_id", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "score",                  default: 0,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "api_keys", "users"
  add_foreign_key "guesses", "spots"
  add_foreign_key "guesses", "users"
  add_foreign_key "score_transactions", "users"
  add_foreign_key "spots", "games"
  add_foreign_key "spots", "users"
end
