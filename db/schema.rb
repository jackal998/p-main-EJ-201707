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

ActiveRecord::Schema.define(version: 20181223070423) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.integer  "code"
    t.string   "alias_name"
    t.string   "full_name"
    t.string   "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "chairman"
    t.string   "president"
    t.datetime "establishment"
    t.datetime "listed_date"
    t.string   "tax_ID"
    t.integer  "category_id"
    t.index ["category_id"], name: "index_companies_on_category_id", using: :btree
  end

  create_table "stocks", force: :cascade do |t|
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.datetime "data_datetime"
    t.decimal  "price",         precision: 8, scale: 2
    t.integer  "company_id"
    t.integer  "volume"
    t.index ["company_id"], name: "index_stocks_on_company_id", using: :btree
    t.index ["data_datetime"], name: "index_stocks_on_data_datetime", using: :btree
  end

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "nickname"
    t.string   "show_me_who_u_r"
    t.string   "role"
    t.float    "panel_top"
    t.float    "panel_left"
    t.string   "provider"
    t.string   "provider_uid"
    t.string   "provider_user_name"
    t.string   "provider_avatar"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["provider_uid"], name: "index_users_on_provider_uid", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["show_me_who_u_r"], name: "index_users_on_show_me_who_u_r", using: :btree
  end

end
