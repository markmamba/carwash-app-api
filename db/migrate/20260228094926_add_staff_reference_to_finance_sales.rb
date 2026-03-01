class AddStaffReferenceToFinanceSales < ActiveRecord::Migration[8.1]
  def change
    add_reference :finance_sales, :staff, foreign_key: { to_table: :workforce_staffs }
    add_index :finance_sales, [:date, :staff_id] unless index_name_exists?(:finance_sales, :index_finance_sales_on_date_staff_id)
  end
end
