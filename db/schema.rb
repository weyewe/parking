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

ActiveRecord::Schema.define(version: 20140707075154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contract_items", force: true do |t|
    t.integer  "contract_maintenance_id"
    t.integer  "customer_id"
    t.integer  "item_id"
    t.boolean  "is_deleted",              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contract_maintenances", force: true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.text     "description"
    t.string   "code"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.boolean  "is_deleted",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.text     "pic"
    t.text     "contact"
    t.string   "email"
    t.boolean  "is_deleted", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "customer_id"
    t.integer  "item_type_id"
    t.string   "code"
    t.text     "description"
    t.datetime "manufactured_at"
    t.datetime "warranty_expiry_date"
    t.boolean  "is_deleted",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maintenance_schedules", force: true do |t|
    t.integer  "contract_maintenance_id"
    t.datetime "maintenance_date"
    t.integer  "customer_id"
    t.boolean  "is_deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "maintenances", force: true do |t|
    t.integer  "item_id"
    t.integer  "customer_id"
    t.integer  "user_id"
    t.string   "code"
    t.datetime "complaint_date"
    t.text     "complaint"
    t.integer  "complaint_case"
    t.text     "diagnosis"
    t.integer  "diagnosis_case"
    t.datetime "diagnosis_date"
    t.boolean  "is_diagnosed",   default: false
    t.text     "solution"
    t.integer  "solution_case"
    t.datetime "solution_date"
    t.boolean  "is_solved",      default: false
    t.boolean  "is_confirmed",   default: false
    t.boolean  "is_deleted",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_rule_usages", force: true do |t|
    t.integer  "price_rule_id"
    t.integer  "ticket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "price_rules", force: true do |t|
    t.integer  "vehicle_case"
    t.boolean  "is_base_price",                          default: false
    t.integer  "hour"
    t.decimal  "price",         precision: 10, scale: 2, default: 0.0
    t.boolean  "is_deleted",                             default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.json     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcription_products", force: true do |t|
    t.integer  "duration",                                          default: 0
    t.string   "name"
    t.text     "description"
    t.integer  "vehicle_case"
    t.decimal  "price",                    precision: 10, scale: 2, default: 0.0
    t.boolean  "is_deactivated",                                    default: false
    t.boolean  "deactivation_date"
    t.text     "deactivation_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcription_registrations", force: true do |t|
    t.integer  "subcription_product_id"
    t.integer  "vehicle_registration_id"
    t.datetime "registration_date"
    t.datetime "finish_subcription_date"
    t.datetime "start_subcription_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_deleted",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.string   "name"
    t.string   "username"
    t.string   "login"
    t.boolean  "is_deleted",             default: false
    t.boolean  "is_main_user",           default: false
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vehicle_registrations", force: true do |t|
    t.integer  "customer_id"
    t.integer  "vehicle_id"
    t.boolean  "is_deactivated",           default: false
    t.datetime "deactivation_date"
    t.text     "deactivation_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vehicles", force: true do |t|
    t.string   "license_plate_no"
    t.integer  "vehicle_case"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
