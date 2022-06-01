class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :mail, null: false
      t.boolean :publish, default: false, null: false
      t.boolean :account_delete, default: false, null: false
      t.boolean :admin_authority, default: false, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, [:name, :mail], unique: true
  end
end
