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

ActiveRecord::Schema.define(version: 2018_05_19_103604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }
    t.string "color", default: "#727e96"
    t.string "css"
    t.index ["user_id"], name: "index_apps_on_user_id"
    t.index ["uuid"], name: "index_apps_on_uuid", unique: true
  end

  create_table "releases", force: :cascade do |t|
    t.string "version", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.bigint "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "draft", default: true
    t.index ["app_id"], name: "index_releases_on_app_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "auth0_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["auth0_id"], name: "index_users_on_auth0_id", unique: true
  end

  add_foreign_key "apps", "users"
  add_foreign_key "releases", "apps"
end
