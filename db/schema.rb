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

ActiveRecord::Schema[8.1].define(version: 2026_02_28_094923) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "sales", force: :cascade do |t|
    t.decimal "admin_commission", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.decimal "service_fee", precision: 8, scale: 2, null: false
    t.decimal "staff_commission", precision: 8, scale: 2, null: false
    t.bigint "staff_id", null: false
    t.datetime "updated_at", null: false
    t.string "vehicle_plate", limit: 20, null: false
    t.bigint "vehicle_type_id", null: false
    t.index ["date", "staff_id"], name: "index_sales_on_date_and_staff_id"
    t.index ["date"], name: "index_sales_on_date"
    t.index ["staff_id"], name: "index_sales_on_staff_id"
    t.index ["vehicle_plate"], name: "index_sales_on_vehicle_plate"
    t.index ["vehicle_type_id"], name: "index_sales_on_vehicle_type_id"
  end

  create_table "staff_schedules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.time "end_time", null: false
    t.bigint "staff_id", null: false
    t.time "start_time", null: false
    t.string "status", default: "scheduled"
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_staff_schedules_on_date"
    t.index ["staff_id", "date"], name: "index_staff_schedules_on_staff_id_and_date"
    t.index ["staff_id"], name: "index_staff_schedules_on_staff_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "address"
    t.decimal "commission_rate", precision: 5, scale: 4, default: "0.4"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.date "hire_date"
    t.string "name", null: false
    t.string "phone", limit: 50
    t.decimal "total_commission_earned", precision: 10, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_staffs_on_active"
    t.index ["email"], name: "index_staffs_on_email", unique: true
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.decimal "base_price", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.string "type_name", null: false
    t.datetime "updated_at", null: false
    t.index ["type_name"], name: "index_vehicle_types_on_type_name", unique: true
  end

  add_foreign_key "sales", "staffs"
  add_foreign_key "sales", "vehicle_types"
  add_foreign_key "staff_schedules", "staffs"
end
