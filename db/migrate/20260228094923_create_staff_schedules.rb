class CreateStaffSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :staff_schedules do |t|
      t.references :staff, null: false, foreign_key: true
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.string :status, default: 'scheduled'

      t.timestamps
    end

    add_index :staff_schedules, :staff_id unless index_name_exists?(:staff_schedules, :index_staff_schedules_on_staff_id)
    add_index :staff_schedules, :date unless index_name_exists?(:staff_schedules, :index_staff_schedules_on_date)
    add_index :staff_schedules, [:staff_id, :date] unless index_name_exists?(:staff_schedules, :index_staff_schedules_on_staff_id_and_date)
  end
end
