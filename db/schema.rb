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

ActiveRecord::Schema.define(version: 2019_07_02_131555) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.bigint "user_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_attachments_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.boolean "prefer_gender_male", default: false
    t.boolean "prefer_gender_female", default: true
    t.integer "prefer_min_age", default: 18
    t.integer "prefer_max_age", default: 25
    t.integer "prefer_location_distance", default: 10
    t.boolean "is_show_in_app", default: true
    t.boolean "is_show_in_places", default: true
    t.string "work"
    t.string "education"
    t.string "about_you"
    t.integer "relationship", default: 0
    t.integer "sexuality", default: 0
    t.integer "height"
    t.integer "living", default: 0
    t.integer "children", default: 0
    t.integer "smoking", default: 0
    t.integer "drinking", default: 0
    t.string "speak", default: [], array: true
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "instagram_photos_url", default: [], array: true
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "phone_number"
    t.string "code_country"
    t.string "tokens", default: [], array: true
    t.boolean "is_verified", default: false
    t.string "name"
    t.datetime "birth_date"
    t.string "country"
    t.string "city"
    t.integer "gender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_account_block", default: false
    t.string "firebase_token"
    t.float "lat"
    t.float "lng"
  end

  add_foreign_key "attachments", "users"
  add_foreign_key "profiles", "users"
end
