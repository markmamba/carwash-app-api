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

ActiveRecord::Schema[8.1].define(version: 2026_02_28_094926) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "finance_expenses", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "approved_at"
    t.bigint "approved_by_id"
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.text "description", null: false
    t.date "expense_date", null: false
    t.text "notes"
    t.string "receipt_number"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.string "vendor"
    t.index ["approved_by_id"], name: "index_finance_expenses_on_approved_by_id"
    t.index ["category"], name: "index_finance_expenses_on_category"
    t.index ["created_by_id"], name: "index_finance_expenses_on_created_by_id"
    t.index ["expense_date", "category"], name: "index_finance_expenses_on_expense_date_and_category"
    t.index ["expense_date"], name: "index_finance_expenses_on_expense_date"
    t.index ["status", "expense_date"], name: "index_finance_expenses_on_status_and_expense_date"
    t.index ["status"], name: "index_finance_expenses_on_status"
  end

  create_table "finance_sales", force: :cascade do |t|
    t.decimal "admin_commission", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.decimal "service_fee", precision: 8, scale: 2, null: false
    t.decimal "staff_commission", precision: 8, scale: 2, null: false
    t.bigint "staff_id"
    t.datetime "updated_at", null: false
    t.string "vehicle_plate", limit: 20, null: false
    t.bigint "vehicle_type_id", null: false
    t.index ["date", "staff_id"], name: "index_finance_sales_on_date_and_staff_id"
    t.index ["date"], name: "index_finance_sales_on_date"
    t.index ["staff_id"], name: "index_finance_sales_on_staff_id"
    t.index ["vehicle_plate"], name: "index_finance_sales_on_vehicle_plate"
    t.index ["vehicle_type_id"], name: "index_finance_sales_on_vehicle_type_id"
  end

  create_table "identities_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "password_digest"
    t.string "phone_number"
    t.datetime "updated_at", null: false
    t.string "user_type", default: "staff", null: false
    t.index ["email"], name: "index_identities_users_on_email", unique: true
    t.index ["user_type"], name: "index_identities_users_on_user_type"
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.decimal "base_price", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.string "type_name", null: false
    t.datetime "updated_at", null: false
    t.index ["type_name"], name: "index_vehicle_types_on_type_name", unique: true
  end

  create_table "workforce_schedules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.time "end_time", null: false
    t.text "notes"
    t.date "shift_date", null: false
    t.bigint "staff_id", null: false
    t.time "start_time", null: false
    t.string "status", default: "scheduled", null: false
    t.datetime "updated_at", null: false
    t.index ["shift_date"], name: "index_workforce_schedules_on_shift_date"
    t.index ["staff_id", "shift_date"], name: "index_workforce_schedules_on_staff_id_and_shift_date"
    t.index ["staff_id"], name: "index_workforce_schedules_on_staff_id"
  end

  create_table "workforce_staffs", force: :cascade do |t|
    t.decimal "commission_rate", precision: 5, scale: 2, default: "40.0", null: false
    t.datetime "created_at", null: false
    t.string "department"
    t.date "hire_date", null: false
    t.string "role", null: false
    t.string "staff_id", null: false
    t.string "status", default: "active", null: false
    t.decimal "total_commission_earned", precision: 10, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["role"], name: "index_workforce_staffs_on_role"
    t.index ["staff_id"], name: "index_workforce_staffs_on_staff_id", unique: true
    t.index ["status"], name: "index_workforce_staffs_on_status"
    t.index ["user_id"], name: "index_workforce_staffs_on_user_id", unique: true
  end

  add_foreign_key "finance_expenses", "identities_users", column: "approved_by_id"
  add_foreign_key "finance_expenses", "identities_users", column: "created_by_id"
  add_foreign_key "finance_sales", "vehicle_types"
  add_foreign_key "finance_sales", "workforce_staffs", column: "staff_id"
  add_foreign_key "workforce_schedules", "workforce_staffs", column: "staff_id"
  add_foreign_key "workforce_staffs", "identities_users", column: "user_id"
end
