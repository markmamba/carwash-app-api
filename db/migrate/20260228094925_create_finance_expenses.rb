class CreateFinanceExpenses < ActiveRecord::Migration[8.1]
  def change
    create_table :finance_expenses do |t|
      t.date :expense_date, null: false
      t.text :description, null: false
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.string :category, null: false
      t.string :status, null: false, default: 'pending'
      t.string :receipt_number
      t.string :vendor
      t.text :notes
      t.references :approved_by, foreign_key: { to_table: :identities_users }
      t.references :created_by, null: false, foreign_key: { to_table: :identities_users }
      t.datetime :approved_at
      t.timestamps null: false
    end

    add_index :finance_expenses, :expense_date unless index_name_exists?(:finance_expenses, :index_finance_expenses_on_expense_date)
    add_index :finance_expenses, :category unless index_name_exists?(:finance_expenses, :index_finance_expenses_on_category)
    add_index :finance_expenses, :status unless index_name_exists?(:finance_expenses, :index_finance_expenses_on_status)
    add_index :finance_expenses, :approved_by_id unless index_name_exists?(:finance_expenses, :index_finance_expenses_on_approved_by_id)
    add_index :finance_expenses, :created_by_id unless index_name_exists?(:finance_expenses, :index_finance_expenses_on_created_by_id)
    add_index :finance_expenses, [:expense_date, :category] unless index_name_exists?(:finance_expenses, :index_finance_expenses_on_expense_date_category)
    add_index :finance_expenses, [:status, :expense_date] unless index_name_exists?(:finance_expenses, :index_finance_expenses_on_status_expense_date)
  end
end
