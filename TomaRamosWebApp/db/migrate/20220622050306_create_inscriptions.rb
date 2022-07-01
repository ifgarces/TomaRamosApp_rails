class CreateInscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :inscriptions do |t|
      t.timestamps
    end
  end
end
