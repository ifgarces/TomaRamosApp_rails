class CreateRamoEventTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :ramo_event_types do |t|
      t.string :name, limit: 60

      t.timestamps
    end
  end
end
