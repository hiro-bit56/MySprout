# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_28_062024) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "mood_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "mood", null: false
    t.date "record_date", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["record_date", "mood"], name: "index_mood_records_on_record_date_and_mood", unique: true
    t.index ["user_id", "record_date"], name: "index_mood_records_on_user_id_and_record_date", unique: true
    t.index ["user_id"], name: "index_mood_records_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "crypted_password", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "salt", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "mood_records", "users"
end
