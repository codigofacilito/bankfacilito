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

ActiveRecord::Schema[7.2].define(version: 2024_12_12_141131) do
  create_table "accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "account_number"
    t.integer "account_type"
    t.integer "balance"
    t.string "CLABE"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default", default: false
    t.integer "account_type", default: 0, null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "recipients", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_recipients_on_account_id"
    t.index ["user_id"], name: "index_recipients_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_services_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "transaction_type", default: 0
    t.decimal "amount", default: "0.0"
    t.text "description", default: ""
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "pin_digest"
    t.boolean "biometric_enabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "recipients", "accounts"
  add_foreign_key "recipients", "users"
  add_foreign_key "services", "accounts"
  add_foreign_key "transactions", "accounts"
end
