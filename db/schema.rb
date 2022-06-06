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

ActiveRecord::Schema.define(version: 2022_06_06_061449) do

  create_table "dai_number_close_days", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "dai_week_number"
    t.string "dai_close_day_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_dai_number_close_days_on_user_id"
  end

  create_table "settings", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "publish", default: false, null: false
    t.boolean "weekly_repeat", default: true, null: false
    t.boolean "element_id_flag", default: true, null: false
    t.string "title"
    t.string "element_name"
    t.string "background_color", default: "CC0000", null: false
    t.string "font_color", default: "FFFFFF", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "weekly_days"
    t.string "others_close_days"
    t.string "next_month_others_close_days"
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "mail", null: false
    t.boolean "publish", default: false, null: false
    t.boolean "account_delete", default: false, null: false
    t.boolean "admin_authority", default: false, null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "mail"], name: "index_users_on_name_and_mail", unique: true
  end

  add_foreign_key "dai_number_close_days", "users"
  add_foreign_key "settings", "users"
end
