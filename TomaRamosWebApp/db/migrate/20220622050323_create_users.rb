class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, limit: 128, null: false
      t.string :username, limit: 64, null: false
      t.string :password_digest
      t.boolean :is_admin, default: false #TODO: improve this, use roles instead, etc.

      t.timestamps
    end
  end
end
