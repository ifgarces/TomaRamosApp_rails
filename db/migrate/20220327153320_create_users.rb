class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :tag, limit: 60
      t.string :password_digest
      t.string :first_name, limit: 100
      t.string :last_name, limit: 100

      t.timestamps
    end
    add_index :users, :tag, unique: true
  end
end
