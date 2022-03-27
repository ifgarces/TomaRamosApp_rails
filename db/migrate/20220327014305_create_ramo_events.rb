class CreateRamoEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :ramo_events do |t|
      t.string :location, limit: 30
      t.string :day_of_week, limit: 30
      t.time :start_time
      t.time :end_time
      t.date :date

      t.timestamps
    end
  end
end
