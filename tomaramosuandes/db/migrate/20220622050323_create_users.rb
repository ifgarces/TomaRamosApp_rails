class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, limit: 128
      t.string :username, limit: 64
      t.string :password_digest

      t.timestamps
    end
  end
end
