require "date"

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, limit: 128, null: false
      t.string :password_digest
      t.datetime :last_activity, default: DateTime.now()
      t.boolean :is_admin, default: false

      t.timestamps
    end
  end
end
