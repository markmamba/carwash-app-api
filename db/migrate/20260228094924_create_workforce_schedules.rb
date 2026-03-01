class CreateWorkforceSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :workforce_schedules do |t|
      t.references :staff, null: false, foreign_key: { to_table: :workforce_staffs }
      t.date :shift_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :status, null: false, default: 'scheduled'
      t.text :notes
      t.timestamps null: false
    end

    add_index :workforce_schedules, :staff_id unless index_name_exists?(:workforce_schedules, :index_workforce_schedules_on_staff_id)
    add_index :workforce_schedules, :shift_date unless index_name_exists?(:workforce_schedules, :index_workforce_schedules_on_shift_date)
    add_index :workforce_schedules, [:staff_id, :shift_date] unless index_name_exists?(:workforce_schedules, :index_workforce_schedules_on_staff_id_shift_date)
  end
end
