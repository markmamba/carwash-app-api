class CreateSales < ActiveRecord::Migration[8.1]
  def change
    create_table :sales do |t|
      t.date :date, null: false
      t.string :vehicle_plate, null: false, limit: 20
      t.decimal :service_fee, precision: 8, scale: 2, null: false
      t.decimal :admin_commission, precision: 8, scale: 2, null: false
      t.decimal :staff_commission, precision: 8, scale: 2, null: false
      t.references :staff, null: false, foreign_key: true
      t.references :vehicle_type, null: false, foreign_key: true

      t.timestamps
    end

    add_index :sales, :date unless index_name_exists?(:sales, :index_sales_on_date)
    add_index :sales, :vehicle_plate unless index_name_exists?(:sales, :index_sales_on_vehicle_plate)
    add_index :sales, [:date, :staff_id] unless index_name_exists?(:sales, :index_sales_on_date_staff_id)
    add_index :sales, :vehicle_type_id unless index_name_exists?(:sales, :index_sales_on_vehicle_type_id)
  end
end
