class CreateIdentitiesUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :identities_users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.string :password_digest
      t.string :user_type, null: false, default: 'staff'
      t.timestamps null: false
    end

    add_index :identities_users, :email, unique: true
    add_index :identities_users, :user_type
  end
end
