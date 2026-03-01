class CreateFinanceSales < ActiveRecord::Migration[8.1]
  def change
    create_table :finance_sales do |t|
      t.date :date, null: false
      t.string :vehicle_plate, null: false, limit: 20
      t.decimal :service_fee, precision: 8, scale: 2, null: false
      t.decimal :admin_commission, precision: 8, scale: 2, null: false
      t.decimal :staff_commission, precision: 8, scale: 2, null: false
      t.references :vehicle_type, null: false, foreign_key: { to_table: :vehicle_types }
      t.timestamps null: false
    end

    add_index :finance_sales, :date unless index_name_exists?(:finance_sales, :index_finance_sales_on_date)
    add_index :finance_sales, :vehicle_plate unless index_name_exists?(:finance_sales, :index_finance_sales_on_vehicle_plate)
    add_index :finance_sales, :vehicle_type_id unless index_name_exists?(:finance_sales, :index_finance_sales_on_vehicle_type_id)
  end
end
