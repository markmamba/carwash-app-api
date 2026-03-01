class CreateWorkforceStaffs < ActiveRecord::Migration[8.1]
  def change
    create_table :workforce_staffs do |t|
      t.references :user, null: false, foreign_key: { to_table: :identities_users }, index: { unique: true }
      t.string :staff_id, null: false
      t.string :role, null: false
      t.string :department
      t.decimal :commission_rate, precision: 5, scale: 2, null: false, default: 40.00
      t.date :hire_date, null: false
      t.string :status, null: false, default: 'active'
      t.decimal :total_commission_earned, precision: 10, scale: 2, default: 0.00
      t.timestamps null: false
    end

    add_index :workforce_staffs, :staff_id, unique: true
    add_index :workforce_staffs, :status
    add_index :workforce_staffs, :role
  end
end
