class CreateRamoEventTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :ramo_event_types do |t|
      t.string :name, limit: 60, null: false

      t.timestamps
    end
    add_index :ramo_event_types, :name, unique: true
  end
end
