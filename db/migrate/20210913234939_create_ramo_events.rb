class CreateRamoEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :ramo_events do |t|
      t.integer :type
      t.integer :day_of_week
      t.datetime :start_timestamp
      t.datetime :end_timestamp
      t.date :date

      t.timestamps
    end
  end
end
