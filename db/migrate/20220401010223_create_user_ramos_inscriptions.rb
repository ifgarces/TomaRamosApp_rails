class CreateUserRamosInscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_ramos_inscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :ramos, null: false, foreign_key: true

      t.timestamps
    end
  end
end
