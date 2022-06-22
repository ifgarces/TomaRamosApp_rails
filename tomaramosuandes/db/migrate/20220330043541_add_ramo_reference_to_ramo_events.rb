class AddRamoReferenceToRamoEvents < ActiveRecord::Migration[7.0]
  def change
    add_reference :ramo_events, :ramo, null: false, foreign_key: true
  end
end
