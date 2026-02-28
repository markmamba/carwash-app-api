class CreateVehicleTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicle_types do |t|
      t.string :type_name, null: false
      t.decimal :base_price, precision: 8, scale: 2, null: false

      t.timestamps
    end

    add_index :vehicle_types, :type_name, unique: true unless index_name_exists?(:vehicle_types, :index_vehicle_types_on_type_name)
  end
end
