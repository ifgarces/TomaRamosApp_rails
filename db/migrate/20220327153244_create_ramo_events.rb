class CreateRamoEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :ramo_events do |t|
      t.string :location,    limit: 60
      t.string :day_of_week, limit: 16
      t.time :start_time,    null: false
      t.time :end_time,      null: false
      t.date :date

      t.timestamps
    end
  end
end
