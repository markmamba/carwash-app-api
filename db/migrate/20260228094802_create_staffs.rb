class CreateStaffs < ActiveRecord::Migration[8.1]
  def change
    create_table :staffs do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, limit: 50
      t.text :address
      t.date :hire_date
      t.decimal :commission_rate, precision: 5, scale: 4, default: 0.40
      t.decimal :total_commission_earned, precision: 10, scale: 2, default: 0.00
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :staffs, :email, unique: true unless index_name_exists?(:staffs, :index_staffs_on_email)
    add_index :staffs, :active unless index_name_exists?(:staffs, :index_staffs_on_active)
  end
end
