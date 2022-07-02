class AddUserForeignKeyToInscription < ActiveRecord::Migration[7.0]
  def change
    add_reference :inscriptions, :user, null: false, foreign_key: true
  end
end
