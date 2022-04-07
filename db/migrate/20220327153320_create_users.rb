class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email,        limit: 60, null: false, unique: true # for authentication
      t.string :tag,          limit: 60, null: false # custom unique user tag string
      t.string :display_name, limit: 150, null: false
      t.string :profile_bio,  limit: 256

      t.timestamps
    end
    add_index :users, :tag, unique: true
  end
end
